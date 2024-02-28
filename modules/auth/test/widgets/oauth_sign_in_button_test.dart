import 'package:auth/auth.dart';
import 'package:auth/data/enum/auth_type_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("OAuthSign In Button Test", () {
    testWidgets('OAuthSignInButton Widget Test - iOS',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: OAuthSignInButton(
              type: AuthType.signIn,
            ),
          ),
        ),
      );
      expect(find.byType(AppleSignInButton), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsNothing);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('OAuthSignInButton Widget Test - Android',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(
        const TestApp(
          home: Material(
            child: OAuthSignInButton(
              type: AuthType.signIn,
            ),
          ),
        ),
      );
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(find.byType(AppleSignInButton), findsNothing);

      debugDefaultTargetPlatformOverride = null;
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
