import 'package:isar/isar.dart';

part 'genre.g.dart';

@Embedded()
class Genre {
  late int id;
  late String name;

  @override
  String toString() {
    return 'Genre{id: $id, name: $name}';
  }
}
