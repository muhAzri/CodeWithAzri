import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTextFormField tests', () {
    testWidgets('Initial state test', (WidgetTester tester) async {
      bool isObscured = false;

      await tester.pumpWidget(
        TestApp(
          home: Scaffold(
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

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(isObscured, false); // Check initial state for isObscured
    });

    testWidgets('Toggle obscure text test', (WidgetTester tester) async {
      bool isObscured = false;

      await tester.pumpWidget(
        TestApp(
          home: Scaffold(
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
        TestApp(
          home: Scaffold(
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
      prefixIconsAssets: '../../assets/icons/email.png',
      hintText: 'Enter your text here',
      controller: controller,
      obscureText: isObscured,
      onSuffixTapped: () {
        toggleObscure(!isObscured);
      },
    );
  }
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
