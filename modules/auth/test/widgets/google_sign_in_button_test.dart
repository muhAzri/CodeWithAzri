import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoogleSignInButton tests', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(16.0),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Widget has correct width', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.width, equals(274.w));
    });

    testWidgets('Widget has correct padding and margin',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
              margin: EdgeInsets.all(20.0),
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.padding,
          equals(const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0)));
      expect(containerWidget.margin, equals(const EdgeInsets.all(20.0)));
    });

    testWidgets('Widget onTap callback is triggered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(),
          ),
        ),
      );

      final inkWellFinder = find.byType(InkWell);
      await tester.tap(inkWellFinder, warnIfMissed: false);
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
