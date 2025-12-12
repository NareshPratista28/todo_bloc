/*

DATABASE REPO

This implement the todo repo and handles storing, retrieving, updating, and deleting todos from the Isar database.

*/

import 'package:isar/isar.dart';
import 'package:todo_bloc/data/models/isar_todo.dart';
import 'package:todo_bloc/domain/models/todo.dart';
import 'package:todo_bloc/domain/repository/todo_repo.dart';

class IsarTodoRepo implements TodoRepo {
  // database
  final Isar db;
  IsarTodoRepo({required this.db});

  // get todos
  @override
  Future<List<Todo>> getTodos() async {
    // fetch from isar db
    final todos = await db.todoIsars.where().findAll();
    // return as a list of todos and give to domain layer
    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  // add todo
  @override
  Future<void> addTodo(Todo newTodo) async {
    final todoIsar = TodoIsar.fromDomain(newTodo);
    return db.writeTxn(() async {
      await db.todoIsars.put(todoIsar);
    });
  }

  // update todo
  @override
  Future<void> updateTodo(Todo todo) {
    final todoIsar = TodoIsar.fromDomain(todo);
    return db.writeTxn(() async {
      await db.todoIsars.put(todoIsar);
    });
  }

  // delete todo
  @override
  Future<void> deleteTodo(int todoId) async {
    await db.writeTxn(() async {
      await db.todoIsars.delete(todoId);
    });
  }
}
