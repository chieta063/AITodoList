import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_todo_list/widgets/empty_todo_list.dart';

Widget createTestWidget() {
  return MaterialApp(home: const EmptyTodoList());
}

void main() {
  group('EmptyTodoListの基本表示', () {
    testWidgets('EmptyTodoListは正しいアイコンを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.task_alt), findsOneWidget);
    });

    testWidgets('EmptyTodoListは正しいメッセージを表示すること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Todoがありません'), findsOneWidget);
      expect(find.text('新しいTodoを追加してください'), findsOneWidget);
    });

    testWidgets('EmptyTodoListはCenterウィジェットでラップされていること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('EmptyTodoListはColumnウィジェットを使用していること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    testWidgets('EmptyTodoListは適切な間隔を持つこと', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });

    testWidgets('EmptyTodoListはグレーの色を使用していること', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // アイコンの色を確認
      final iconFinder = find.byIcon(Icons.task_alt);
      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, Colors.grey);

      // テキストの色を確認
      final textFinder = find.text('Todoがありません');
      final text = tester.widget<Text>(textFinder);
      expect(text.style?.color, Colors.grey);
    });

    testWidgets('EmptyTodoListは適切なフォントサイズを使用していること', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final textFinder = find.text('Todoがありません');
      final text = tester.widget<Text>(textFinder);
      expect(text.style?.fontSize, 18);
    });
  });
}
