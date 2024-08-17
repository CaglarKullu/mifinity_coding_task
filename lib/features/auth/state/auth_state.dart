import '../models/user.dart';

enum AuthStateStatus { authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStateStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});

  AuthState copyWith({
    AuthStateStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
