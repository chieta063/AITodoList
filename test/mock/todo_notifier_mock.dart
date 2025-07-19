import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';
import 'package:ai_todo_list/models/todo.dart';

// Mockクラスを生成するためのアノテーション
@GenerateMocks(
  [],
  customMocks: [MockSpec<TodoNotifier>(as: #MockTodoNotifierForTest)],
)
void main() {}

// Mockデータの作成
class TodoMockData {
  static Todo createMockTodo({
    String id = 'mock-id',
    String title = 'Mock Todo',
    bool isCompleted = false,
  }) {
    return Todo(id: id, title: title, isCompleted: isCompleted);
  }

  static List<Todo> createMockTodoList() {
    return [
      createMockTodo(id: '1', title: 'Mock Todo 1', isCompleted: false),
      createMockTodo(id: '2', title: 'Mock Todo 2', isCompleted: true),
      createMockTodo(id: '3', title: 'Mock Todo 3', isCompleted: false),
    ];
  }

  static List<Todo> createEmptyMockTodoList() {
    return [];
  }

  static List<Todo> createSingleMockTodoList() {
    return [
      createMockTodo(id: '1', title: 'Single Mock Todo', isCompleted: false),
    ];
  }
}
