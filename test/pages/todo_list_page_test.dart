import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/pages/todo_list_page.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';

void main() {
  group('TodoListPageウィジェットのテスト', () {
    Widget createTestWidget() {
      return ProviderScope(child: MaterialApp(home: const TodoListPage()));
    }

    testWidgets('TodoListPageはタイトル付きのアプリバーを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Todo一覧'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('TodoListPageは新しいTodo用のテキストフィールドを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('新しいTodoを入力'), findsOneWidget);
    });

    testWidgets('TodoListPageは追加ボタンを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoがない場合に空の状態を表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Todoがありません'), findsOneWidget);
      expect(find.text('新しいTodoを追加してください'), findsOneWidget);
      expect(find.byIcon(Icons.task_alt), findsOneWidget);
    });

    testWidgets('TodoListPageはテキストが入力され追加ボタンが押された場合にTodoを追加すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // テキストフィールドにテキストを入力
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.pump();

      // 追加ボタンをタップ
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが追加されたことを確認
      expect(find.text('New Todo'), findsOneWidget);
      expect(find.text('Todoがありません'), findsNothing);
    });

    testWidgets('TodoListPageはEnterが押された場合にTodoを追加すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // テキストを入力してEnterを押す
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Todoが追加されたことを確認
      expect(find.text('New Todo'), findsOneWidget);
    });

    testWidgets('TodoListPageは空のTodoを追加しないこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 空のTodoを追加しようとする
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが追加されなかったことを確認
      expect(find.text('Todoがありません'), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoを追加した後にテキストフィールドをクリアすること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // テキストを入力してTodoを追加
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // テキストフィールドがクリアされたことを確認
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('TodoListPageは複数のTodoを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 複数のTodoを追加
      await tester.enterText(find.byType(TextField), 'Todo 1');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Todo 2');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // 両方のTodoが表示されることを確認
      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoが存在する場合にListViewを持つこと', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Todoを追加
      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // ListViewが存在することを確認
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
