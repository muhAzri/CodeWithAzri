import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('OnboardLogo widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: OnboardLogo(),
          ),
        ),
      );

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
        const TestApp(
          home: Material(
            child: TagLine(),
          ),
        ),
      );

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
        const TestApp(
          home: Material(
            child: DescriptionSection(),
          ),
        ),
      );

      // Verify if DescriptionSection widget is present
      expect(find.byType(Container), findsOneWidget);
      expect(
          find.text(
              "New way to study abroad from the real professional with great work."),
          findsOneWidget);

      // Add more specific tests for the DescriptionSection widget
      expect(
          find.descendant(
              of: find.byType(Container),
              matching: find.text(
                  "New way to study abroad from the real professional with great work.")),
          findsOneWidget);
    });

    testWidgets('CreateNewAccountButton widget test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: CreateNewAccountButton(),
          ),
        ),
      );

      // Verify if CreateNewAccountButton widget is present
      expect(find.byType(CustomButton), findsOneWidget);
      expect(find.text('Create New Account'), findsOneWidget);

      await tester.tap(find.byType(InkWell), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text("Sign Up"), findsOneWidget);
    });

    testWidgets('GoToSignInButton widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: GoToSignInButton(),
          ),
        ),
      );

      // Verify if GoToSignInButton widget is present
      expect(find.byType(CustomTextButton), findsOneWidget);
      expect(find.text('Sign In to My Account'), findsOneWidget);

      await tester.tap(find.byType(InkWell), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text("Sign In"), findsOneWidget);
    });

    testWidgets("OnboardScreen widget test", (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: OnboardScreen(),
          ),
        ),
      );

      expect(find.byType(OnboardLogo), findsOneWidget);
      expect(find.byType(TagLine), findsOneWidget);
      expect(find.byType(DescriptionSection), findsOneWidget);
      expect(find.byType(CreateNewAccountButton), findsOneWidget);
      expect(find.byType(GoToSignInButton), findsOneWidget);
    });
  });
}

class TestApp extends StatelessWidget {
  final Widget home;
  const TestApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(393, 847),
    );
    return MaterialApp(
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
