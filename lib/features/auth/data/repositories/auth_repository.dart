import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/user.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  Isar? _isar;

  @override
  Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([UserSchema], directory: dir.path);
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return await _isar!.users.filter().emailEqualTo(email).findFirst();
  }

  @override
  Future<void> registerUser(User user) async {
    await _isar!.writeTxn(() async {
      await _isar!.users.put(user);
    });
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    return await _isar!.users
        .filter()
        .emailEqualTo(email)
        .and()
        .passwordEqualTo(password)
        .findFirst();
  }

  @override
  Future<void> logoutUser() async {
    // Implement logout logic if needed, such as clearing user session data
  }
}
