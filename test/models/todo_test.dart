import 'package:flutter_test/flutter_test.dart';
import 'package:ai_todo_list/models/todo.dart';

void main() {
  group('Todoモデルのテスト', () {
    test('Todoは正しい初期値で作成されること', () {
      const id = '1';
      const title = 'Test Todo';

      final todo = Todo(id: id, title: title);

      expect(todo.id, equals(id));
      expect(todo.title, equals(title));
      expect(todo.isCompleted, isFalse);
    });

    test('TodoはカスタムのisCompleted値で作成されること', () {
      const id = '1';
      const title = 'Test Todo';

      final todo = Todo(id: id, title: title, isCompleted: true);

      expect(todo.id, equals(id));
      expect(todo.title, equals(title));
      expect(todo.isCompleted, isTrue);
    });

    test('copyWithは更新された値で新しいTodoを作成すること', () {
      final originalTodo = Todo(
        id: '1',
        title: 'Original Todo',
        isCompleted: false,
      );

      final updatedTodo = originalTodo.copyWith(
        title: 'Updated Todo',
        isCompleted: true,
      );

      expect(updatedTodo.id, equals('1'));
      expect(updatedTodo.title, equals('Updated Todo'));
      expect(updatedTodo.isCompleted, isTrue);
    });

    test('copyWithは指定されていない場合は元の値を保持すること', () {
      final originalTodo = Todo(
        id: '1',
        title: 'Original Todo',
        isCompleted: false,
      );

      final updatedTodo = originalTodo.copyWith(isCompleted: true);

      expect(updatedTodo.id, equals('1'));
      expect(updatedTodo.title, equals('Original Todo'));
      expect(updatedTodo.isCompleted, isTrue);
    });

    test('copyWithは指定されたフィールドのみを更新すること', () {
      final originalTodo = Todo(
        id: '1',
        title: 'Original Todo',
        isCompleted: false,
      );

      final updatedTodo = originalTodo.copyWith(title: 'New Title');

      expect(updatedTodo.id, equals('1'));
      expect(updatedTodo.title, equals('New Title'));
      expect(updatedTodo.isCompleted, isFalse);
    });
  });
}
