import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  group('CustomButton Widget Tests', () {
    testWidgets('Renders button with provided label',
        (WidgetTester tester) async {
      const String label = 'Submit';
      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomButton(
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
          child: CustomButton(
            label: 'Button',
            onTap: mockOnTap,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell));
      verify(() => mockOnTap.call()).called(1);
    });

    testWidgets('Applies provided height and width',
        (WidgetTester tester) async {
      double customHeight = 100;
      double customWidth = 200;

      final Key customButtonKey = UniqueKey();

      await tester.pumpWidget(
        TestApp(
          home: Material(
            child: Scaffold(
              body: CustomButton(
                key: customButtonKey,
                label: 'Button',
                onTap: mockOnTap,
                height: customHeight,
                width: customWidth,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Finder customButton = find.byKey(customButtonKey);
      expect(tester.getSize(customButton).height, equals(customHeight));
      expect(tester.getSize(customButton).width, equals(customWidth));
    });

    testWidgets('Applies provided padding', (WidgetTester tester) async {
      const EdgeInsets customPadding = EdgeInsets.all(8.0);

      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomButton(
            label: 'Button',
            onTap: mockOnTap,
            padding: customPadding,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final Finder container = find
          .descendant(
            of: find.byType(CustomButton),
            matching: find.byType(Container),
          )
          .first;
      expect(
        tester.widget<Container>(container).padding,
        equals(customPadding),
      );
    });

    testWidgets('Uses default styles if none provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
        home: Material(
          child: CustomButton(
            label: 'Button',
            onTap: mockOnTap,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      final Finder text = find.text('Button');
      expect(tester.widget<Text>(text).style!.color, equals(Colors.white));
      expect(tester.widget<Text>(text).style!.fontSize, equals(16.sp));
      expect(
          tester.widget<Text>(text).style!.fontWeight, equals(FontWeight.w600));
    });
  });
}
