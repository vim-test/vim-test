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

    testWidgets(
      'has very very very very very very very very very very very long description',
      (WidgetTester tester) async {
      await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

      final titleFinder = find.text('T');
      final messageFinder = find.text('M');

      expect(titleFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
    });

    testWidgets(
        'test with string array and very very very very very very very very very very very long description',
        (tester) async {
      final a = [
        'a',
        'b',
        'c',
      ];

      await tester.pumpWidget(
        const Center(),
      );
      await tester.pump();

      expect(find.text('Jan 24'), findsOneWidget);
    });

    testWidgets('a "b"', (WidgetTester tester) async {
      await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

      final titleFinder = find.text('T');
      final messageFinder = find.text('M');

      expect(titleFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
    });

    testWidgets("a 'b'", (WidgetTester tester) async {
      await tester.pumpWidget(MyWidget(title: 'T', message: 'M'));

      final titleFinder = find.text('T');
      final messageFinder = find.text('M');

      expect(titleFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
    });
  });
}
