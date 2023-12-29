import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('OnboardLogo widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: OnboardLogo(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      expect(
          find.descendant(
              of: find.byType(Container), matching: find.byType(Padding)),
          findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('TagLine widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: TagLine(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify if TagLine widget is present
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('Learn.'), findsOneWidget);
      expect(find.text('Practice.'), findsOneWidget);
      expect(find.text('Earn.'), findsOneWidget);

      // Add more specific tests for the TagLine widget
      expect(
          find.descendant(
              of: find.byType(Column), matching: find.text('Learn.')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(Column), matching: find.text('Practice.')),
          findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(Column), matching: find.text('Earn.')),
          findsOneWidget);
    });

    testWidgets('DescriptionSection widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: DescriptionSection(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify if DescriptionSection widget is present
      expect(find.byType(Container), findsOneWidget);
      expect(find.text("onboardDescription"), findsOneWidget);

      // Add more specific tests for the DescriptionSection widget
      expect(
          find.descendant(
              of: find.byType(Container),
              matching: find.text("onboardDescription")),
          findsOneWidget);
    });

    testWidgets('CreateNewAccountButton widget test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: CreateNewAccountButton(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify if CreateNewAccountButton widget is present
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('onboardCreateAccountButtonLabel'), findsOneWidget);

      await tester.tap(find.byType(InkWell), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text("Sign Up"), findsOneWidget);
    });

    testWidgets('GoToSignInButton widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: GoToSignInButton(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify if GoToSignInButton widget is present
      expect(find.byType(CustomTextButton), findsOneWidget);
      expect(find.text('onboardGoToSignInButtonLabel'), findsOneWidget);

      await tester.tap(find.byType(InkWell), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text("Sign In"), findsOneWidget);
    });

    testWidgets("OnboardScreen widget test", (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalTestApp(
          home: Material(
            child: OnboardScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnboardLogo), findsOneWidget);
      expect(find.byType(TagLine), findsOneWidget);
      expect(find.byType(DescriptionSection), findsOneWidget);
      expect(find.byType(CreateNewAccountButton), findsOneWidget);
      expect(find.byType(GoToSignInButton), findsOneWidget);
    });
  });
}

class LocalTestApp extends StatelessWidget {
  final Widget home;
  const LocalTestApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return LocalizationTestApp(
      routes: {
        '/': (_) => home,
        '/sign-in': (_) => const MockRoutePage(
              text: "Sign In",
            ),
        '/sign-up': (_) => const MockRoutePage(
              text: "Sign Up",
            ),
      },
    );
  }
}

class MockRoutePage extends StatelessWidget {
  final String text;
  const MockRoutePage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
        ),
      ),
    );
  }
}
