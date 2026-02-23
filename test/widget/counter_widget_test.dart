import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_demo/widgets/counter_widget.dart';

void main() {
  group('CounterWidget', () {
    testWidgets('should display initial count of 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 0),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display custom initial count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 5),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should increment counter when add button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 10),
          ),
        ),
      );

      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('11'), findsOneWidget);
    });

    testWidgets('should decrement counter when remove button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 5),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('should increment multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 0),
          ),
        ),
      );

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('increment_button')));
        await tester.pump();
      }

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should handle mixed increment and decrement',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 10),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();
      expect(find.text('11'), findsOneWidget);

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();
      expect(find.text('9'), findsOneWidget);
    });

    testWidgets('should display both buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(),
          ),
        ),
      );

      expect(find.byKey(const Key('increment_button')), findsOneWidget);
      expect(find.byKey(const Key('decrement_button')), findsOneWidget);
    });

    testWidgets('should find counter text by key',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CounterWidget(initialCount: 42),
          ),
        ),
      );

      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.byKey(const Key('counter_text')), findsWidgets);
    });

    testWidgets('should call onIncrement callback',
        (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterWidget(
              initialCount: 0,
              onIncrement: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });

    testWidgets('should call onDecrement callback',
        (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterWidget(
              initialCount: 5,
              onDecrement: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(callbackCalled, isTrue);
    });
  });
}
