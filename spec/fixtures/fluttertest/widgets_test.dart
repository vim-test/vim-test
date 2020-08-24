import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });

  group('MyWidget', {
    testWidgets('doesn\'t have description', (WidgetTester tester) async {
      await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

      final descriptionFinder = find.text('D');

      expect(descriptionFinder, findsNothing);
    });
  });
}
