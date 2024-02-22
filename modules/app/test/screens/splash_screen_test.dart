import 'package:app/presentation/screens/splash_screen.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:cwa_core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoutes {
  static const onboardScreen = '/onboard';
  static const mainScreen = '/main';
}

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(PageRouteBuilder<dynamic>(
      pageBuilder: (_, __, ___) => Container(),
    ));
  });

  late NavigatorObserver mockObserver;
  late AuthService mockAuthService;
  late GetIt getIt;

  setUp(() {
    getIt = Locator().getIt;
    getIt.registerSingleton<AuthService>(MockAuthService());
    getIt.registerSingleton<NavigatorObserver>(MockNavigatorObserver());

    mockAuthService = getIt.get<AuthService>();
    mockObserver = getIt.get<NavigatorObserver>();
  });

  tearDown(() {
    getIt.reset();
  });
  group("Splash Screen", () {
    testWidgets('SplashScreen navigation test not sign in',
        (WidgetTester tester) async {
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream<MockUser?>.value(MockUser()));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 847),
          child: MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/': (_) => const SplashScreen(),
              MockRoutes.onboardScreen: (_) => Container(),
              MockRoutes.mainScreen: (_) => Container(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute<void>(
                builder: (_) => Container(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('SplashScreen navigation test signin Authenticated',
        (WidgetTester tester) async {
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream<MockUser?>.value(MockUser()));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 847),
          child: MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/': (_) => const SplashScreen(),
              MockRoutes.onboardScreen: (_) => Container(),
              MockRoutes.mainScreen: (_) => Container(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute<void>(
                builder: (_) => Container(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('SplashScreen navigation test signin Unauthenticated',
        (WidgetTester tester) async {
      when(() => mockAuthService.authStateChanges)
          .thenAnswer((_) => Stream<MockUser?>.value(null));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 847),
          child: MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/': (_) => const SplashScreen(),
              MockRoutes.onboardScreen: (_) => Container(),
              MockRoutes.mainScreen: (_) => Container(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute<void>(
                builder: (_) => Container(),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
