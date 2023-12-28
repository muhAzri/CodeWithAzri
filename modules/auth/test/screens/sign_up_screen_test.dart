import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpScreen Widgets Test', () {
    testWidgets('BuildSignUpHeader Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp(home: BuildSignUpHeader()));
      expect(find.text('Hello Fam 👋'), findsOneWidget);
      expect(find.text('Create your account & enjoy'), findsOneWidget);
    });

    testWidgets('BuildSignUpForms Widget Test', (WidgetTester tester) async {
      await tester
          .pumpWidget(const TestApp(home: Material(child: BuildSignUpForms())));
      expect(find.byType(CustomTextFormField), findsNWidgets(3));
    });

    testWidgets('BuildSignUpButton Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
          const TestApp(home: Material(child: BuildSignUpButton())));
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('BuildHaveAccountButton Widget Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BuildHaveAccountButton(),
            ),
          ),
        ),
      );
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('OAuthSignInButton Widget Test - iOS',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.pumpWidget(
          const TestApp(home: Material(child: OAuthSignInButton())));
      expect(find.byType(AppleSignInButton), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsNothing);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('OAuthSignInButton Widget Test - Android',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
          const TestApp(home: Material(child: OAuthSignInButton())));
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(find.byType(AppleSignInButton), findsNothing);

      debugDefaultTargetPlatformOverride = null;
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
      home: home,
    );
  }
}
