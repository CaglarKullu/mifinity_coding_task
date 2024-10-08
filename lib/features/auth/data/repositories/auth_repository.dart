import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/user.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  Isar _isar;
  AuthRepository(this._isar);

  @override
  Future<void> init() async {}

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final user = await _isar.users.filter().emailEqualTo(email).findFirst();
      log(user != null
          ? 'User found: ${user.email}'
          : 'No user found for email: $email');
      return user;
    } catch (e) {
      log('Error fetching user by email: $e');
      return null; // Returning null in case of an error
    }
  }

  @override
  Future<void> registerUser(User user) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.users.put(user);
      });
      log('User registered: ${user.email}');
    } catch (e) {
      log('Error registering user: $e');
      rethrow; // Re-throwing the exception if necessary
    }
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    try {
      final user = await _isar.users
          .filter()
          .emailEqualTo(email)
          .and()
          .passwordEqualTo(password)
          .findFirst();
      log(user != null
          ? 'User logged in: ${user.email}'
          : 'Invalid login attempt for email: $email');
      return user;
    } catch (e) {
      log('Error logging in user: $e');
      return null; // Returning null in case of an error
    }
  }

  @override
  Future<void> logoutUser() async {
    // Implement logout logic here if needed
    log('User logged out');
  }
}
