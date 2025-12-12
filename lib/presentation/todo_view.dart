/*

TODO VIEW: responsible for UI

- use BlocBuilder to rebuild UI based on state changes

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/domain/models/todo.dart';
import 'package:todo_bloc/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  String _titleForTodos(List<Todo> todos) {
    final remaining = todos.where((t) => !t.isCompleted).length;
    return 'Todos ($remaining)';
  }

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a task'),
        content: TextField(
          controller: textController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            final text = textController.text.trim();
            if (text.isEmpty) return;
            todoCubit.addTodo(text);
            Navigator.of(context).pop();
          },
          decoration: const InputDecoration(
            hintText: 'What do you need to do?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) todoCubit.addTodo(text);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TodoCubit, List<Todo>>(
          builder: (context, todos) => Text(_titleForTodos(todos)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoBox(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 72,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No tasks yet',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first todo.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: todos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final todo = todos[index];
              final key = ValueKey('todo-${todo.id}');

              return Dismissible(
                key: key,
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.delete_outline, color: colorScheme.onError),
                ),
                onDismissed: (_) =>
                    context.read<TodoCubit>().deleteTodo(todo.id),
                child: Material(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () =>
                        context.read<TodoCubit>().toggleTodoCompletion(todo),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: todo.isCompleted,
                            onChanged: (_) => context
                                .read<TodoCubit>()
                                .toggleTodoCompletion(todo),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              todo.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: todo.isCompleted
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.onSurface,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            todo.isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: todo.isCompleted
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
