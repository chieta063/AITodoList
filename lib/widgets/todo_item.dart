import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../notifier/todo_notifier.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(todoProvider.notifier).deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.title}を削除しました'),
            action: SnackBarAction(
              label: '元に戻す',
              onPressed: () {
                ref.read(todoProvider.notifier).addTodo(todo.title);
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            ref.read(todoProvider.notifier).toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ref.read(todoProvider.notifier).deleteTodo(todo.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${todo.title}を削除しました'),
                action: SnackBarAction(
                  label: '元に戻す',
                  onPressed: () {
                    ref.read(todoProvider.notifier).addTodo(todo.title);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
