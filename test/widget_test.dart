// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kalkulator/main.dart';

void main() {
  testWidgets('Calculator smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that calculator starts with 0
    expect(find.text('0'), findsOneWidget);

    // Tap number 5
    await tester.tap(find.text('5'));
    await tester.pump();

    // Verify that 5 is displayed
    expect(find.text('5'), findsOneWidget);
  });
}
