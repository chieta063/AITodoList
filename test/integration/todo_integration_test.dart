import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/pages/todo_list_page.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';

void main() {
  group('Todo統合テスト', () {
    Widget createTestWidget() {
      return ProviderScope(child: MaterialApp(home: const TodoListPage()));
    }

    testWidgets('完全なTodoワークフロー: 追加、切り替え、削除', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // ステップ1: Todoを追加
      await tester.enterText(find.byType(TextField), 'Integration Test Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが追加されたことを確認
      expect(find.text('Integration Test Todo'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // ステップ2: Todoの完了状態を切り替え
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pump();

      // Todoが完了したことを確認（チェックボックスがチェックされる）
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);

      // テキストに取り消し線があることを確認
      final textWidget = tester.widget<Text>(
        find.text('Integration Test Todo'),
      );
      expect(textWidget.style?.decoration, equals(TextDecoration.lineThrough));

      // ステップ3: 完了状態を元に戻す
      await tester.tap(checkbox);
      await tester.pump();

      // Todoが完了していないことを確認
      final updatedCheckboxWidget = tester.widget<Checkbox>(checkbox);
      expect(updatedCheckboxWidget.value, isFalse);

      // テキストに取り消し線がないことを確認
      final updatedTextWidget = tester.widget<Text>(
        find.text('Integration Test Todo'),
      );
      expect(updatedTextWidget.style?.decoration, isNull);

      // ステップ4: 削除ボタンを使ってTodoを削除
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pump();

      // Todoが削除されたことを確認
      expect(find.text('Integration Test Todo'), findsNothing);
      expect(find.text('Todoがありません'), findsOneWidget);
    });

    testWidgets('複数のTodoのワークフロー', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 複数のTodoを追加
      await tester.enterText(find.byType(TextField), 'First Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Second Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Third Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // すべてのTodoが表示されることを確認
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);
      expect(find.text('Third Todo'), findsOneWidget);

      // 最初のTodoを完了
      final firstCheckbox = find.byType(Checkbox).first;
      await tester.tap(firstCheckbox);
      await tester.pump();

      // 最初のTodoが完了したことを確認
      final firstCheckboxWidget = tester.widget<Checkbox>(firstCheckbox);
      expect(firstCheckboxWidget.value, isTrue);

      // 2番目のTodoを削除
      final deleteButtons = find.byIcon(Icons.delete);
      await tester.tap(deleteButtons.at(1)); // 2番目の削除ボタン
      await tester.pump();

      // 2番目のTodoが削除されたことを確認
      expect(find.text('Second Todo'), findsNothing);
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Third Todo'), findsOneWidget);
    });

    testWidgets('削除ボタンを使った削除機能', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Todoを追加
      await tester.enterText(find.byType(TextField), 'Delete Test Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが表示されることを確認
      expect(find.text('Delete Test Todo'), findsOneWidget);

      // 削除ボタンをタップ
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pump();

      // Todoが削除されたことを確認
      expect(find.text('Delete Test Todo'), findsNothing);
      expect(find.text('Todoがありません'), findsOneWidget);
    });

    testWidgets('空の入力の検証', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 空のTodoを追加しようとする
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが追加されなかったことを確認
      expect(find.text('Todoがありません'), findsOneWidget);

      // スペースのみのTodoを追加しようとする
      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Todoが追加されなかったことを確認
      expect(find.text('Todoがありません'), findsOneWidget);
    });

    testWidgets('Todoを追加した後のテキストフィールドのクリア', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Todoを追加
      await tester.enterText(find.byType(TextField), 'Clear Test Todo');
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // テキストフィールドがクリアされたことを確認
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);

      // プレースホルダーテキストがまだ表示されることを確認
      expect(find.text('新しいTodoを入力'), findsOneWidget);
    });
  });
}
