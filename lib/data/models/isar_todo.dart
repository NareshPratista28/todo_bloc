/*

ISAR TODO MODEL

Converts a TODO model into an ISAR database model.

*/

import 'package:isar/isar.dart';
import 'package:todo_bloc/domain/models/todo.dart';

// To generate isar todo object, run: dart run build_runner build
part 'isar_todo.g.dart';

@Collection()
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;

  // Convert isar object -> pure todo object to use in our app
  Todo toDomain() {
    return Todo(id: id, text: text, isCompleted: isCompleted);
  }

  // Convert pure todo object -> isar object to store in database
  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted;
  }
}
