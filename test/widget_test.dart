import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamora/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StreamoraApp());

    // Verify that splash screen elements are present
    expect(find.text('Streamora'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
