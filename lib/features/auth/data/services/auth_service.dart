import '../../../../core/utils/security.dart';
import '../../models/user.dart';
import '../repositories/auth_repository_interface.dart';

class AuthService {
  final AuthRepositoryInterface authRepository;

  AuthService(this.authRepository);

  Future<String?> register(String email, String password) async {
    // Check if the user already exists
    final existingUser = await authRepository.getUserByEmail(email);
    if (existingUser != null) {
      return 'User with this email already exists.';
    }

    // Generate a salt and hash the password
    final salt = Security.generateSalt();
    final passwordHash = Security.hashPassword(password, salt);

    // Register the new user
    final user = User(email: email, passwordHash: passwordHash, salt: salt);
    await authRepository.registerUser(user);
    return null; // Indicating success
  }

  Future<User?> login(String email, String password) async {
    final user = await authRepository.getUserByEmail(email);
    if (user != null &&
        Security.verifyPassword(password, user.salt, user.passwordHash)) {
      return user;
    }
    return null; // Authentication failed
  }

  Future<void> logout() async {
    await authRepository.logoutUser();
  }
}
