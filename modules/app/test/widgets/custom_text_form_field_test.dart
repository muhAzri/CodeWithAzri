import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('CustomTextFormField tests', () {
    testWidgets('Initial state test', (WidgetTester tester) async {
      bool isObscured = false;

      await tester.pumpWidget(
        LocalizationTestApp(
          child: Builder(builder: (context) {
            return Scaffold(
              body: CustomTextFormTestWidget(
                (value) {
                  isObscured = value;
                },
                isObscured: isObscured,
              ),
            );
          }),
        ),
      );

      await tester.pumpAndSettle();

      final errorLocalizationWidget =
          find.textContaining("Error Localization:");

      if (errorLocalizationWidget.evaluate().isNotEmpty) {
        debugDumpApp();
      }

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(isObscured, false); // Check initial state for isObscured
    });

    testWidgets('Toggle obscure text test', (WidgetTester tester) async {
      bool isObscured = false;

      await tester.pumpWidget(
        LocalizationTestApp(
          child: Scaffold(
            body: CustomTextFormTestWidget(
              (value) {
                isObscured = value;
              },
              isObscured: isObscured,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Icon));
      await tester.pump();

      expect(
          isObscured, true); // Check if the text is obscured after tapping icon
    });

    testWidgets('Enter text in TextFormField test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        LocalizationTestApp(
          child: Scaffold(
            body: CustomTextFormTestWidget(
              (value) {},
              isObscured: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Hello, World!');

      expect(find.text('Hello, World!'), findsOneWidget);
    });
  });
}

class CustomTextFormTestWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final Function(bool) toggleObscure;
  final bool isObscured;

  CustomTextFormTestWidget(this.toggleObscure,
      {super.key, required this.isObscured});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      prefixIconsAssets: AssetsManager.emailIcon,
      hintText: 'Enter your text here',
      controller: controller,
      obscureText: isObscured,
      onSuffixTapped: () {
        toggleObscure(!isObscured);
      },
    );
  }
}
