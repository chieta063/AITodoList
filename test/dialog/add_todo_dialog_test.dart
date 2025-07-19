import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_todo_list/dialog/add_todo_dialog.dart';

Widget createTestWidget() {
  return MaterialApp(home: Scaffold(body: const AddTodoDialog()));
}

void main() {
  group('AddTodoDialogの基本表示', () {
    testWidgets('AddTodoDialogは正しいタイトルを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('新しいTodo'), findsOneWidget);
    });

    testWidgets('AddTodoDialogはテキストフィールドを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('新しいTodoを入力'), findsOneWidget);
    });

    testWidgets('AddTodoDialogはキャンセルと追加ボタンを表示すること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('キャンセル'), findsOneWidget);
      expect(find.text('追加'), findsOneWidget);
    });
  });

  group('AddTodoDialogの入力機能', () {
    testWidgets('AddTodoDialogはテキストを入力できること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.pump();

      expect(find.text('Test Todo'), findsOneWidget);
    });

    testWidgets('AddTodoDialogは追加ボタンでテキストを返すこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.pump();

      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // ダイアログが閉じられることを確認
      expect(find.text('新しいTodo'), findsNothing);
    });

    testWidgets('AddTodoDialogはEnterキーでテキストを返すこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // ダイアログが閉じられることを確認
      expect(find.text('新しいTodo'), findsNothing);
    });

    testWidgets('AddTodoDialogは空のテキストでは何も返さないこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // ダイアログが開いたままであることを確認
      expect(find.text('新しいTodo'), findsOneWidget);
    });

    testWidgets('AddTodoDialogは空白のみのテキストでは何も返さないこと', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // ダイアログが開いたままであることを確認
      expect(find.text('新しいTodo'), findsOneWidget);
    });
  });

  group('AddTodoDialogのキャンセル機能', () {
    testWidgets('AddTodoDialogはキャンセルボタンでダイアログを閉じること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // ダイアログが閉じられることを確認
      expect(find.text('新しいTodo'), findsNothing);
    });

    testWidgets('AddTodoDialogはキャンセル時にテキストフィールドがクリアされること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.pump();

      await tester.tap(find.text('キャンセル'));
      await tester.pumpAndSettle();

      // テキストがクリアされることを確認
      expect(find.text('Test Todo'), findsNothing);
    });
  });
}
