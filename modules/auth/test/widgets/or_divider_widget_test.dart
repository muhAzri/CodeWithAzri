import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OrDividerWidget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const TestApp(
        home: Scaffold(
          body: OrDividerWidget(),
        ),
      ),
    );

    // Find the Divider widget
    final dividerFinder = find.byType(Divider);
    expect(dividerFinder, findsOneWidget);

    // Find the Text widget containing 'OR'
    final textFinder = find.text('OR');
    expect(textFinder, findsOneWidget);

    // Ensure the 'OR' text has the correct style
    final textWidget = tester.widget<Text>(textFinder);
    expect(textWidget.style!.fontSize,
        equals(16.sp.toDouble()));

    // Ensure the Alignment of the 'OR' text is centered
    final alignWidget = tester.widget<Align>(find.byType(Align));
    expect(alignWidget.alignment, equals(Alignment.center));
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
