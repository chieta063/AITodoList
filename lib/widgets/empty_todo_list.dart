import 'package:flutter/material.dart';

class EmptyTodoList extends StatelessWidget {
  const EmptyTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Todoがありません',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text('新しいTodoを追加してください', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
