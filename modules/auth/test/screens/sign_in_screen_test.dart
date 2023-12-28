import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInScreen Widgets Test', () {
    testWidgets('BuildSignInHeader Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp(home: BuildSignInHeader()));
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign In to your account'), findsOneWidget);
    });

    testWidgets('BuildSignInForms Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: BuildSignInForms(),
          ),
        ),
      );
      expect(
        find.byType(CustomTextFormField),
        findsNWidgets(2),
      );
      expect(find.byType(CustomTextButton), findsOneWidget);
    });

    testWidgets('BuildSignInButton Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: BuildSignInButton(),
          ),
        ),
      );
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('BuildCreateAccountButton Widget Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BuildCreateAccountButton(),
            ),
          ),
        ),
      );
      expect(find.text('Dont have account? '), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('SignInScreen Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: MediaQuery(
              // Shrink the text avoid overflow caused by large Ahem font.
              data: MediaQueryData(textScaler: TextScaler.linear(0.5)),
              child: SignInScreen(),
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
