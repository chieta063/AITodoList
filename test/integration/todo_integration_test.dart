import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_todo_list/pages/todo_list_page.dart';
import 'package:ai_todo_list/notifier/todo_notifier.dart';

Widget createTestWidget() {
  return ProviderScope(child: MaterialApp(home: const TodoListPage()));
}

void main() {
  group('Todoの追加機能', () {
    testWidgets('Todoの追加と完了状態の切り替え', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Todoを追加
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Integration Test Todo');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // Todoが追加されたことを確認
      expect(find.text('Integration Test Todo'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // Todoの完了状態を切り替え
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
    });

    testWidgets('複数のTodoの追加', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 複数のTodoを追加
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'First Todo');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Second Todo');
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // すべてのTodoが表示されることを確認
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);
    });
  });

  group('入力検証', () {
    testWidgets('空の入力の検証', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // 空のTodoを追加しようとする
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      // Todoが追加されなかったことを確認
      expect(find.text('Todoがありません'), findsOneWidget);
    });
  });
}
