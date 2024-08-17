import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String email;
  String? password;
  late String passwordHash;
  late String salt;

  User({
    required this.email,
    required this.passwordHash,
    required this.salt,
  });
  @override
  String toString() {
    return 'User{id: $id, email: $email}';
  }
}
