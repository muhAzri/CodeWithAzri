import 'package:app/presentation/screens/main_screen.dart';
import 'package:cwa_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/presentation/screens/home_screen.dart';

void main() {
  group('MainScreen widget test group', () {
    testWidgets('Initial screen is home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Switching to my course screen via bottom navigation bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: MainScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu_book_outlined));
      await tester.pumpAndSettle();
      expect(find.text("My Course Screen"), findsOneWidget);
    });

    testWidgets('Switching to profile screen via bottom navigation bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: MainScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text("Profile Screen"), findsOneWidget);
    });

    testWidgets('Switching to the same screen via bottom navigation bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: MainScreen(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text("Profile Screen"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text("Profile Screen"), findsOneWidget);
    });
  });
}
