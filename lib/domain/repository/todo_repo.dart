/*
Todo Repository

Here you can define what the app can do.
*/

import 'package:todo_bloc/domain/models/todo.dart';

abstract class TodoRepo {
  // get list of todos
  Future<List<Todo>> getTodos();

  // add a new todo
  Future<void> addTodo(Todo newTodo);

  // update a todo
  Future<void> updateTodo(Todo updatedTodo);

  // delete a todo
  Future<void> deleteTodo(int todoId);
}
