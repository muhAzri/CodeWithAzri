import 'package:app/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoutes {
  static const onboardScreen = '/onboardScreen';
}

void main() {
  setUpAll(() {
    registerFallbackValue(PageRouteBuilder<dynamic>(
      pageBuilder: (_, __, ___) => Container(),
    ));
  });

  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });
  testWidgets('SplashScreen navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 847),
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/': (_) => const SplashScreen(),
            MockRoutes.onboardScreen: (_) => Container(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute<void>(
              builder: (_) => Container(),
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(Image), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
  });
}
