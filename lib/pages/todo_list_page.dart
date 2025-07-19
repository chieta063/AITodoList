import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/todo_notifier.dart';
import '../widgets/todo_item.dart';
import '../widgets/empty_todo_list.dart';
import '../dialog/add_todo_dialog.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  void _showAddTodoDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (result != null && result.isNotEmpty) {
      ref.read(todoNotifierProvider.notifier).addTodo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo一覧'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: todos.isEmpty
          ? const EmptyTodoList()
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return TodoItem(todo: todos[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
