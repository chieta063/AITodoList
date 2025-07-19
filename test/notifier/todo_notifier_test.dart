import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';
import '../mock/todo_notifier_mock.dart';
import '../mock/todo_notifier_mock.mocks.dart';

void main() {
  group('TodoNotifierの初期状態', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('初期状態は空のリストであること', () {
      final todos = container.read(todoNotifierProvider);
      expect(todos, isEmpty);
    });
  });

  group('Todoの追加機能', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('addTodoForTestで新しいTodoがリストに追加されること', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoNotifierProvider);
      expect(todos.length, equals(1));
      expect(todos.first.title, equals('Test Todo'));
      expect(todos.first.isCompleted, isFalse);
      expect(todos.first.id, equals('id1'));
    });

    test('addTodoForTestで異なるIDのTodoを複数追加できること', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Todo 1');
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoNotifierProvider);
      expect(todos.length, equals(2));
      expect(todos[0].title, equals('Todo 1'));
      expect(todos[1].title, equals('Todo 2'));
      expect(todos[0].id, equals('id1'));
      expect(todos[1].id, equals('id2'));
    });
  });

  group('Todoの完了状態切り替え', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('toggleTodoでTodoの完了状態が切り替わること', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoNotifierProvider);
      final todoId = todos.first.id;
      expect(todos.first.isCompleted, isFalse);
      container.read(todoNotifierProvider.notifier).toggleTodo(todoId);
      final updatedTodos = container.read(todoNotifierProvider);
      expect(updatedTodos.first.isCompleted, isTrue);
      container.read(todoNotifierProvider.notifier).toggleTodo(todoId);
      final finalTodos = container.read(todoNotifierProvider);
      expect(finalTodos.first.isCompleted, isFalse);
    });

    test('toggleTodoで指定したTodoのみが切り替わること', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Todo 1');
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoNotifierProvider);
      final firstTodoId = todos[0].id;
      final secondTodoId = todos[1].id;
      container.read(todoNotifierProvider.notifier).toggleTodo(firstTodoId);
      final updatedTodos = container.read(todoNotifierProvider);
      final firstTodo = updatedTodos.firstWhere(
        (todo) => todo.id == firstTodoId,
      );
      final secondTodo = updatedTodos.firstWhere(
        (todo) => todo.id == secondTodoId,
      );
      expect(firstTodo.isCompleted, isTrue);
      expect(secondTodo.isCompleted, isFalse);
    });
  });

  group('Todoの削除機能', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('deleteTodoで指定したTodoがリストから削除されること', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Todo 1');
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id2', 'Todo 2');
      final todos = container.read(todoNotifierProvider);
      expect(todos.length, equals(2));
      final todoToDelete = todos.first.id;
      container.read(todoNotifierProvider.notifier).deleteTodo(todoToDelete);
      final remainingTodos = container.read(todoNotifierProvider);
      expect(remainingTodos.length, equals(1));
      expect(remainingTodos.any((todo) => todo.id == todoToDelete), isFalse);
    });

    test('deleteTodoで他のTodoには影響しないこと', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Todo 1');
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id2', 'Todo 2');
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id3', 'Todo 3');
      final todos = container.read(todoNotifierProvider);
      final todoToDelete = todos[1].id;
      final todoToKeep = todos[0].id;
      container.read(todoNotifierProvider.notifier).deleteTodo(todoToDelete);
      final remainingTodos = container.read(todoNotifierProvider);
      expect(remainingTodos.length, equals(2));
      expect(remainingTodos.any((todo) => todo.id == todoToKeep), isTrue);
      expect(remainingTodos.any((todo) => todo.id == todoToDelete), isFalse);
    });

    test('deleteTodoで存在しないIDを指定してもリストが変化しないこと', () {
      container
          .read(todoNotifierProvider.notifier)
          .addTodoForTest('id1', 'Test Todo');
      final todos = container.read(todoNotifierProvider);
      expect(todos.length, equals(1));
      container
          .read(todoNotifierProvider.notifier)
          .deleteTodo('non-existent-id');
      final remainingTodos = container.read(todoNotifierProvider);
      expect(remainingTodos.length, equals(1));
    });
  });

  group('Mockitoを使用したTodoNotifierのテスト', () {
    late MockTodoNotifierForTest mockTodoNotifier;

    setUp(() {
      mockTodoNotifier = MockTodoNotifierForTest();
    });

    test('MockTodoNotifierのaddTodoメソッドが呼ばれること', () {
      // Mockの振る舞いを設定
      when(
        mockTodoNotifier.state,
      ).thenReturn(TodoMockData.createEmptyMockTodoList());

      // メソッドを呼び出し
      mockTodoNotifier.addTodo('Test Todo');

      // メソッドが呼ばれたことを検証
      verify(mockTodoNotifier.addTodo('Test Todo')).called(1);
    });

    test('MockTodoNotifierのtoggleTodoメソッドが呼ばれること', () {
      // Mockの振る舞いを設定
      when(
        mockTodoNotifier.state,
      ).thenReturn(TodoMockData.createSingleMockTodoList());

      // メソッドを呼び出し
      mockTodoNotifier.toggleTodo('1');

      // メソッドが呼ばれたことを検証
      verify(mockTodoNotifier.toggleTodo('1')).called(1);
    });

    test('MockTodoNotifierのdeleteTodoメソッドが呼ばれること', () {
      // Mockの振る舞いを設定
      when(
        mockTodoNotifier.state,
      ).thenReturn(TodoMockData.createMockTodoList());

      // メソッドを呼び出し
      mockTodoNotifier.deleteTodo('1');

      // メソッドが呼ばれたことを検証
      verify(mockTodoNotifier.deleteTodo('1')).called(1);
    });

    test('MockTodoNotifierのstateが正しく返されること', () {
      final mockTodoList = TodoMockData.createMockTodoList();

      // Mockの振る舞いを設定
      when(mockTodoNotifier.state).thenReturn(mockTodoList);

      // stateを取得
      final result = mockTodoNotifier.state;

      // 結果を検証
      expect(result, equals(mockTodoList));
      expect(result.length, equals(3));
      expect(result[0].title, equals('Mock Todo 1'));
      expect(result[1].title, equals('Mock Todo 2'));
      expect(result[2].title, equals('Mock Todo 3'));
    });
  });
}
