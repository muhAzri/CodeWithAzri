import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  late MockVoidCallback mockOnTap;

  setUp(() {
    mockOnTap = MockVoidCallback();
  });

  group('CustomTextButton Widget Tests', () {
    testWidgets('Renders button with provided label',
        (WidgetTester tester) async {
      const String label = 'Submit';
      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomTextButton(
            label: label,
            onTap: mockOnTap,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text(label), findsOneWidget);
    });

    testWidgets('Calls onTap callback when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomTextButton(
            label: 'Button',
            onTap: mockOnTap,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      verify(() => mockOnTap.call()).called(1);
    });

    testWidgets('Applies provided padding', (WidgetTester tester) async {
      const EdgeInsets customPadding = EdgeInsets.all(8.0);

      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomTextButton(
            label: 'Button',
            onTap: mockOnTap,
            padding: customPadding,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final Finder container = find.byType(Container);
      expect(
        tester.widget<Container>(container).padding,
        equals(customPadding),
      );
    });

    testWidgets('Uses provided label text style', (WidgetTester tester) async {
      const TextStyle customTextStyle = TextStyle(color: Colors.blue);

      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomTextButton(
            label: 'Button',
            onTap: mockOnTap,
            labelTextStyle: customTextStyle,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final Finder text = find.text('Button');
      expect(
        tester.widget<Text>(text).style,
        equals(customTextStyle),
      );
    });
  });
}
