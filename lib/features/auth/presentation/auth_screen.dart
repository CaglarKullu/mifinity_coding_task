import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mifinity_coding_task/routes/app_router.gr.dart';
import '../../../core/global_providers/global_providers.dart';
import '../../../core/utils/validation.dart';
import '../state/auth_state.dart';
import '../state/auth_view_model.dart';

@RoutePage()
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleFormMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLogin) {
        await ref.read(authViewModelProvider.notifier).login(email, password);
      } else {
        await ref
            .read(authViewModelProvider.notifier)
            .register(email, password);
      }

      if (mounted) {
        final authState = ref.read(authViewModelProvider);

        if (authState.status == AuthStateStatus.error ||
            authState.status == AuthStateStatus.unauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.errorMessage ?? 'Authentication failed'),
            ),
          );
        } else if (authState.status == AuthStateStatus.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          // Navigate to the main screen
          AutoRouter.of(context).replace(const MainRoute());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepositoryState = ref.watch(authRepositoryProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    double formWidth = screenWidth * 0.9;
    if (screenWidth > 600) {
      formWidth = screenWidth * 0.8;
    }
    if (screenWidth > 1000) {
      formWidth = screenWidth * 0.6;
    }

    return authRepositoryState.when(
      data: (authRepository) {
        final authState = ref.watch(authViewModelProvider);

        return Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset:
              true, // Allow resizing when the keyboard appears
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // Dismiss the keyboard when tapping outside
            },
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: formWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Fakeflix',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.white),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validation.validateEmail(
                              value!), // Use the validation utility
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.white),
                          ),
                          obscureText: true,
                          validator: (value) =>
                              Validation.validatePassword(value!),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: authState.status == AuthStateStatus.loading
                              ? const CircularProgressIndicator.adaptive()
                              : Text(
                                  _isLogin ? 'Login' : 'Register',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                        ),
                        TextButton(
                          onPressed: _toggleFormMode,
                          child: Text(
                            _isLogin
                                ? 'Don\'t have an account? Register'
                                : 'Already have an account? Login',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        if (_isLogin)
                          TextButton(
                            onPressed: () {
                              // Implement Forgot Password functionality here
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error initializing app: $error'),
        ),
      ),
    );
  }
}
