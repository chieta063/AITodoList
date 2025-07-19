import 'package:flutter_test/flutter_test.dart';
import 'package:ai_todo_list/models/todo.dart';
import '../mock/todo_notifier_mock.dart';

void main() {
  group('Todoの初期化', () {
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

    test('Mockデータを使用してTodoが正しく作成されること', () {
      final mockTodo = TodoMockData.createMockTodo(
        id: 'mock-id',
        title: 'Mock Todo',
        isCompleted: false,
      );

      expect(mockTodo.id, equals('mock-id'));
      expect(mockTodo.title, equals('Mock Todo'));
      expect(mockTodo.isCompleted, isFalse);
    });
  });

  group('Todoの更新機能', () {
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

  group('Mockデータの検証', () {
    test('MockTodoListが正しく作成されること', () {
      final mockTodoList = TodoMockData.createMockTodoList();

      expect(mockTodoList.length, equals(3));
      expect(mockTodoList[0].id, equals('1'));
      expect(mockTodoList[0].title, equals('Mock Todo 1'));
      expect(mockTodoList[0].isCompleted, isFalse);
      expect(mockTodoList[1].id, equals('2'));
      expect(mockTodoList[1].title, equals('Mock Todo 2'));
      expect(mockTodoList[1].isCompleted, isTrue);
      expect(mockTodoList[2].id, equals('3'));
      expect(mockTodoList[2].title, equals('Mock Todo 3'));
      expect(mockTodoList[2].isCompleted, isFalse);
    });

    test('空のMockTodoListが正しく作成されること', () {
      final emptyMockTodoList = TodoMockData.createEmptyMockTodoList();

      expect(emptyMockTodoList, isEmpty);
      expect(emptyMockTodoList.length, equals(0));
    });

    test('単一のMockTodoListが正しく作成されること', () {
      final singleMockTodoList = TodoMockData.createSingleMockTodoList();

      expect(singleMockTodoList.length, equals(1));
      expect(singleMockTodoList[0].id, equals('1'));
      expect(singleMockTodoList[0].title, equals('Single Mock Todo'));
      expect(singleMockTodoList[0].isCompleted, isFalse);
    });
  });
}
