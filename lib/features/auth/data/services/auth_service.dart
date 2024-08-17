import 'dart:developer';

import '../../../../core/utils/security.dart';
import '../../models/user.dart';
import '../repositories/auth_repository_interface.dart';

class AuthService {
  final AuthRepositoryInterface authRepository;

  AuthService(this.authRepository);

  Future<String?> register(String email, String password) async {
    try {
      // Check if the user already exists
      final existingUser = await authRepository.getUserByEmail(email);
      if (existingUser != null) {
        return 'User with this email already exists.';
      }

      // Generate a salt and hash the password
      final salt = Security.generateSalt();
      final passwordHash = Security.hashPassword(password, salt);

      // Log the generated values
      log('Generated salt: $salt');
      log('Generated passwordHash: $passwordHash');

      // Ensure that all fields are initialized when creating the User object
      final user = User(
        email: email,
        passwordHash: passwordHash,
        salt: salt,
      );

      log('User object created: ${user.email}');

      // Register the new user
      await authRepository.registerUser(user);
      return null; // Indicating success
    } catch (e) {
      log('Error registering user: $e');
      return 'Registration failed: $e';
    }
  }

  Future<User?> login(String email, String password) async {
    final user = await authRepository.getUserByEmail(email);

    if (user != null) {
      final isPasswordValid =
          Security.verifyPassword(password, user.salt, user.passwordHash);
      if (isPasswordValid) {
        return user;
      } else {}
    } else {
      log('AuthService: No user found for email: $email');
    }

    return null; // Authentication failed
  }

  Future<void> logout() async {
    await authRepository.logoutUser();
  }
}
