import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository.dart';
import '../data/services/auth_service.dart';
import '../models/user.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthViewModel(this.authService)
      : super(AuthState(status: AuthStateStatus.unauthenticated));

  Future<void> register(String email, String password) async {
    state = AuthState(status: AuthStateStatus.loading);
    try {
      final error = await authService.register(email, password);
      if (error == null) {
        state = AuthState(
            status: AuthStateStatus.authenticated,
            user: User(email: email, passwordHash: '', salt: ''));
      } else {
        state = AuthState(status: AuthStateStatus.error, errorMessage: error);
      }
    } catch (e) {
      state =
          AuthState(status: AuthStateStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStateStatus.loading);
    try {
      final user = await authService.login(email, password);
      if (user != null) {
        state = AuthState(status: AuthStateStatus.authenticated, user: user);
      } else {
        state = AuthState(
            status: AuthStateStatus.unauthenticated,
            errorMessage: 'Invalid email or password');
      }
    } catch (e) {
      state =
          AuthState(status: AuthStateStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await authService.logout();
    state = AuthState(status: AuthStateStatus.unauthenticated);
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = AuthRepository();
  final authService = AuthService(authRepository);
  return AuthViewModel(authService);
});
