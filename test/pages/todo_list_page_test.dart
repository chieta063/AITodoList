import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/pages/todo_list_page.dart';
import 'package:ai_todo_list/widgets/empty_todo_list.dart';
import 'package:ai_todo_list/dialog/add_todo_dialog.dart';

Widget createTestWidget() {
  return ProviderScope(child: MaterialApp(home: const TodoListPage()));
}

void main() {
  group('TodoListPageの基本表示', () {
    testWidgets('TodoListPageはタイトル付きのアプリバーを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Todo一覧'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('TodoListPageはFloatingActionButtonを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoがない場合に空の状態を表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Todoがありません'), findsOneWidget);
      expect(find.text('新しいTodoを追加してください'), findsOneWidget);
      expect(find.byIcon(Icons.task_alt), findsOneWidget);
      expect(find.byType(EmptyTodoList), findsOneWidget);
    });
  });

  group('ダイアログ機能', () {
    testWidgets('TodoListPageはFloatingActionButtonをタップするとダイアログを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップ
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // ダイアログが表示されることを確認
      expect(find.text('新しいTodo'), findsOneWidget);
      expect(find.byType(AddTodoDialog), findsOneWidget);
      expect(find.text('新しいTodoを入力'), findsOneWidget);
      expect(find.text('キャンセル'), findsOneWidget);
      expect(find.text('追加'), findsOneWidget);
    });

    testWidgets('TodoListPageはダイアログでテキストが入力され追加ボタンが押された場合にTodoを追加すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップしてダイアログを表示
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // ダイアログ内のテキストフィールドにテキストを入力
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.pump();

      // 追加ボタンをタップ
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // Todoが追加されたことを確認
      expect(find.text('New Todo'), findsOneWidget);
      expect(find.text('Todoがありません'), findsNothing);
    });

    testWidgets('TodoListPageはダイアログでEnterが押された場合にTodoを追加すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップしてダイアログを表示
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // テキストを入力してEnterを押す
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Todoが追加されたことを確認
      expect(find.text('New Todo'), findsOneWidget);
    });

    testWidgets('TodoListPageは空のTodoを追加しないこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップしてダイアログを表示
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // 空のTodoを追加しようとする
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // Todoが追加されなかったことを確認
      expect(find.text('Todoがありません'), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoを追加した後にダイアログを閉じること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップしてダイアログを表示
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // テキストを入力してTodoを追加
      await tester.enterText(find.byType(TextField), 'New Todo');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // ダイアログが閉じられたことを確認
      expect(find.byType(AddTodoDialog), findsNothing);
      expect(find.text('新しいTodo'), findsNothing);
    });

    testWidgets('TodoListPageはキャンセルボタンでダイアログを閉じること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // FloatingActionButtonをタップしてダイアログを表示
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // キャンセルボタンをタップ
      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // ダイアログが閉じられたことを確認
      expect(find.byType(AddTodoDialog), findsNothing);
      expect(find.text('新しいTodo'), findsNothing);
    });
  });

  group('Todoの表示機能', () {
    testWidgets('TodoListPageは複数のTodoを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 1つ目のTodoを追加
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Todo 1');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // 2つ目のTodoを追加
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Todo 2');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // 両方のTodoが表示されることを確認
      expect(find.text('Todo 1'), findsOneWidget);
      expect(find.text('Todo 2'), findsOneWidget);
    });

    testWidgets('TodoListPageはTodoが存在する場合にListViewを持つこと', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Todoを追加
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // ListViewが存在することを確認
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
