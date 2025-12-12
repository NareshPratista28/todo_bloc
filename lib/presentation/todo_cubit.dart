/*

TODO CUBIT - SIMPLE STATE MANAGEMENT

Each cubit is a list of todos.

*/

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/domain/models/todo.dart';
import 'package:todo_bloc/domain/repository/todo_repo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  // reference todo repo
  final TodoRepo todoRepo;
  // constructor
  TodoCubit(this.todoRepo) : super([]) {
    // load todos on creation
    loadTodos();
  }

  // load todos from database
  Future<void> loadTodos() async {
    final todoList = await todoRepo.getTodos();
    emit(todoList);
  }

  // add todos from database
  Future<void> addTodo(String text) async {
    final newTodo = Todo(id: DateTime.now().millisecondsSinceEpoch, text: text);
    await todoRepo.addTodo(newTodo);
    loadTodos();
  }

  // delete todos from database

  Future<void> deleteTodo(int todoId) async {
    await todoRepo.deleteTodo(todoId);
    loadTodos();
  }

  // toggle todo completion status in database

  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.toggleCompletion();
    await todoRepo.updateTodo(updatedTodo);
    loadTodos();
  }
}
