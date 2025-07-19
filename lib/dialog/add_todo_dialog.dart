import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      Navigator.of(context).pop(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新しいTodo'),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: '新しいTodoを入力',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (_) => _addTodo(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _textController.clear();
            Navigator.of(context).pop();
          },
          child: const Text('キャンセル'),
        ),
        ElevatedButton(onPressed: _addTodo, child: const Text('追加')),
      ],
    );
  }
}
