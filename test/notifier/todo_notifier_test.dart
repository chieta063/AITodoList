import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';
import 'package:ai_todo_list/models/todo.dart';

void main() {
  group('TodoNotifierのテスト', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は空のリストであること', () {
      final todos = container.read(todoProvider);
      expect(todos, isEmpty);
    });

    test('addTodoForTestで新しいTodoがリストに追加されること', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoProvider);
      expect(todos.length, equals(1));
      expect(todos.first.title, equals('Test Todo'));
      expect(todos.first.isCompleted, isFalse);
      expect(todos.first.id, equals('id1'));
    });

    test('addTodoForTestで異なるIDのTodoを複数追加できること', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Todo 1');
      container.read(todoProvider.notifier).addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoProvider);
      expect(todos.length, equals(2));
      expect(todos[0].title, equals('Todo 1'));
      expect(todos[1].title, equals('Todo 2'));
      expect(todos[0].id, equals('id1'));
      expect(todos[1].id, equals('id2'));
    });

    test('toggleTodoでTodoの完了状態が切り替わること', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoProvider);
      final todoId = todos.first.id;
      expect(todos.first.isCompleted, isFalse);
      container.read(todoProvider.notifier).toggleTodo(todoId);
      final updatedTodos = container.read(todoProvider);
      expect(updatedTodos.first.isCompleted, isTrue);
      container.read(todoProvider.notifier).toggleTodo(todoId);
      final finalTodos = container.read(todoProvider);
      expect(finalTodos.first.isCompleted, isFalse);
    });

    test('toggleTodoで指定したTodoのみが切り替わること', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Todo 1');
      container.read(todoProvider.notifier).addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoProvider);
      final firstTodoId = todos[0].id;
      final secondTodoId = todos[1].id;
      container.read(todoProvider.notifier).toggleTodo(firstTodoId);
      final updatedTodos = container.read(todoProvider);
      final firstTodo = updatedTodos.firstWhere(
        (todo) => todo.id == firstTodoId,
      );
      final secondTodo = updatedTodos.firstWhere(
        (todo) => todo.id == secondTodoId,
      );
      expect(firstTodo.isCompleted, isTrue);
      expect(secondTodo.isCompleted, isFalse);
    });

    test('deleteTodoで指定したTodoがリストから削除されること', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Todo 1');
      container.read(todoProvider.notifier).addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoProvider);
      expect(todos.length, equals(2));
      final todoToDelete = todos.first.id;
      container.read(todoProvider.notifier).deleteTodo(todoToDelete);
      final remainingTodos = container.read(todoProvider);
      expect(remainingTodos.length, equals(1));
      expect(remainingTodos.any((todo) => todo.id == todoToDelete), isFalse);
    });

    test('deleteTodoで他のTodoには影響しないこと', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Todo 1');
      container.read(todoProvider.notifier).addTodoForTest('id2', 'Todo 2');
      container.read(todoProvider.notifier).addTodoForTest('id3', 'Todo 3');
      final todos = container.read(todoProvider);
      final todoToDelete = todos[1].id;
      final todoToKeep = todos[0].id;
      container.read(todoProvider.notifier).deleteTodo(todoToDelete);
      final remainingTodos = container.read(todoProvider);
      expect(remainingTodos.length, equals(2));
      expect(remainingTodos.any((todo) => todo.id == todoToKeep), isTrue);
      expect(remainingTodos.any((todo) => todo.id == todoToDelete), isFalse);
    });

    test('deleteTodoで存在しないIDを指定してもリストが変化しないこと', () {
      container.read(todoProvider.notifier).addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoProvider);
      expect(todos.length, equals(1));
      container.read(todoProvider.notifier).deleteTodo('non-existent-id');
      final remainingTodos = container.read(todoProvider);
      expect(remainingTodos.length, equals(1));
    });
  });
}
