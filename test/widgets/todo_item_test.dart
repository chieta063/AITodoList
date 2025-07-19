import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/widgets/todo_item.dart';
import 'package:ai_todo_list/models/todo.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';

Widget createTestWidget(Todo todo) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: TodoItem(todo: todo)),
    ),
  );
}

void main() {
  group('TodoItemの表示機能', () {
    late Todo testTodo;

    setUp(() {
      testTodo = Todo(id: 'test-id', title: 'Test Todo', isCompleted: false);
    });

    testWidgets('TodoItemはTodoのタイトルを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      expect(find.text('Test Todo'), findsOneWidget);
    });

    testWidgets('TodoItemはチェックボックスを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('TodoItemは削除ボタンを表示しないこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      expect(find.byIcon(Icons.delete), findsNothing);
    });
  });

  group('TodoItemの完了状態表示', () {
    late Todo testTodo;

    setUp(() {
      testTodo = Todo(id: 'test-id', title: 'Test Todo', isCompleted: false);
    });

    testWidgets('TodoItemはTodoが完了した場合に完了スタイルを表示すること', (
      WidgetTester tester,
    ) async {
      final completedTodo = Todo(
        id: 'test-id',
        title: 'Completed Todo',
        isCompleted: true,
      );

      await tester.pumpWidget(createTestWidget(completedTodo));

      final textWidget = tester.widget<Text>(find.text('Completed Todo'));
      expect(textWidget.style?.decoration, equals(TextDecoration.lineThrough));
    });

    testWidgets('TodoItemはTodoが完了していない場合に完了スタイルを表示しないこと', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      final textWidget = tester.widget<Text>(find.text('Test Todo'));
      expect(textWidget.style?.decoration, isNull);
    });
  });

  group('チェックボックスの状態', () {
    late Todo testTodo;

    setUp(() {
      testTodo = Todo(id: 'test-id', title: 'Test Todo', isCompleted: false);
    });

    testWidgets('チェックボックスはTodoが完了していない場合にチェックされていないこと', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('チェックボックスはTodoが完了した場合にチェックされること', (WidgetTester tester) async {
      final completedTodo = Todo(
        id: 'test-id',
        title: 'Completed Todo',
        isCompleted: true,
      );

      await tester.pumpWidget(createTestWidget(completedTodo));

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });
  });

  group('Dismissible機能', () {
    late Todo testTodo;

    setUp(() {
      testTodo = Todo(id: 'test-id', title: 'Test Todo', isCompleted: false);
    });

    testWidgets('TodoItemは削除可能であること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('Dismissibleは正しい方向を持つこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.direction, equals(DismissDirection.endToStart));
    });

    testWidgets('Dismissibleは削除背景を持つこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.background, isA<Container>());
    });

    testWidgets('Dismissibleの背景には削除アイコンが表示されること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testTodo));

      // Dismissibleの背景を確認
      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      final background = dismissible.background as Container;

      // 背景の色が赤であることを確認
      expect(background.color, equals(Colors.red));

      // 背景に削除アイコンが含まれていることを確認
      expect(background.child, isA<Icon>());
      final icon = background.child as Icon;
      expect(icon.icon, equals(Icons.delete));
      expect(icon.color, equals(Colors.white));
    });
  });
}
