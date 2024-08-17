import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/global_providers/global_providers.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';
import '../models/user.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService authService;
  final AuthRepository authRepository;

  AuthViewModel(this.authService, this.authRepository)
      : super(AuthState(status: AuthStateStatus.unauthenticated)) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await authRepository.init();
    } catch (e) {
      log('Database initialization failed: $e');
      state = AuthState(
        status: AuthStateStatus.error,
        errorMessage:
            DatabaseError('Failed to initialize the database: $e').toString(),
      );
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthState(status: AuthStateStatus.loading);
    try {
      final error = await authService.register(email, password);
      if (error == null) {
        state = AuthState(
          status: AuthStateStatus.authenticated,
          user: User(email: email, passwordHash: '', salt: ''),
        );
      } else {
        state = AuthState(
          status: AuthStateStatus.error,
          errorMessage: ApiError(error).toString(),
        );
      }
    } catch (e) {
      log('Registration error: $e');
      state = AuthState(
        status: AuthStateStatus.error,
        errorMessage: _handleError(e).toString(),
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStateStatus.loading);
    try {
      // Check if the user exists before attempting to log in
      final existingUser = await authRepository.getUserByEmail(email);
      if (existingUser == null) {
        state = AuthState(
          status: AuthStateStatus.unauthenticated,
          errorMessage:
              'No account found for this email. Please register first.',
        );
        return;
      }

      // Proceed with login if the user exists
      final user = await authService.login(email, password);

      if (user != null) {
        state = AuthState(
          status: AuthStateStatus.authenticated,
          user: user,
        );
      } else {
        state = AuthState(
          status: AuthStateStatus.unauthenticated,
          errorMessage: 'Invalid email or password',
        );
      }
    } catch (e) {
      log('Login error: $e');
      state = AuthState(
        status: AuthStateStatus.error,
        errorMessage: _handleError(e).toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await authService.logout();
      state = AuthState(status: AuthStateStatus.unauthenticated);
    } catch (e) {
      log('Logout error: $e');
      state = AuthState(
        status: AuthStateStatus.error,
        errorMessage: _handleError(e).toString(),
      );
    }
  }

  AppError _handleError(dynamic error) {
    if (error is NetworkError) {
      return NetworkError(error.message);
    } else if (error is ApiError) {
      return ApiError(error.message);
    } else if (error is DatabaseError) {
      return DatabaseError(error.message);
    } else if (error is ParsingError) {
      return ParsingError(error.message);
    } else {
      return UnknownError('An unknown error occurred: $error');
    }
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider).maybeWhen(
        data: (repo) => repo,
        orElse: () => null,
      );

  if (authRepository == null) {
    throw Exception('AuthRepository not available');
  }

  final authService = AuthService(authRepository);
  return AuthViewModel(authService, authRepository);
});
