import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/todo.dart';

part 'todo_notifier.g.dart';

@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(String title) {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    state = [...state, todo];
  }

  void addTodoWithId(Todo todo) {
    state = [...state, todo];
  }

  void addTodoForTest(String id, String title, {bool isCompleted = false}) {
    final todo = Todo(id: id, title: title, isCompleted: isCompleted);
    state = [...state, todo];
  }

  void toggleTodo(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
