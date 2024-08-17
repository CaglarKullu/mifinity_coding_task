import '../../models/user.dart';

abstract class AuthRepositoryInterface {
  Future<void> init();
  Future<User?> getUserByEmail(String email);
  Future<void> registerUser(User user);
  Future<User?> loginUser(String email, String password);
  Future<void> logoutUser();
}
