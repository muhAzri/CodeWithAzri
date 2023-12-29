import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('SignUpScreen Widgets Test', () {
    testWidgets('BuildSignUpHeader Widget Test', (WidgetTester tester) async {
      await tester
          .pumpWidget(const LocalizationTestApp(child: BuildSignUpHeader()));

      await tester.pumpAndSettle();

      expect(find.text('signUpWelcomeMessage'), findsOneWidget);
      expect(find.text('signUpSubtitle'), findsOneWidget);
    });

    testWidgets('BuildSignUpForms Widget Test', (WidgetTester tester) async {
      await tester
          .pumpWidget(const TestApp(home: Material(child: BuildSignUpForms())));
      expect(find.byType(CustomTextFormField), findsNWidgets(3));
    });

    testWidgets('BuildSignUpButton Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const LocalizationTestApp(
          child: Material(child: BuildSignUpButton())));
      await tester.pumpAndSettle();

      expect(find.text('signUpButtonLabel'), findsOneWidget);
    });

    testWidgets('BuildHaveAccountButton Widget Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: Material(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BuildHaveAccountButton(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('alreadyHaveAnAccountText'), findsOneWidget);
      expect(find.text('signInButtonLabel'), findsOneWidget);
    });

    testWidgets('OrDividerWidget Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp(home: OrDividerWidget()));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('SignUpScreen Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: MediaQuery(
              // Shrink the text avoid overflow caused by large Ahem font.
              data: MediaQueryData(textScaler: TextScaler.linear(0.5)),
              child: SignUpScreen(),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
