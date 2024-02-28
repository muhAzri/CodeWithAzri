import 'package:auth/auth.dart';
import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/data/enum/auth_type_enum.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserService extends Mock implements UserService {}

class MockUser extends Mock implements User {
  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String email;

  MockUser({this.uid = 'id', this.displayName = 'name', this.email = 'email'});
}

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  final AuthService services;
  @override
  final UserService userService;

  MockAuthBloc({required this.services, required this.userService}) {
    when(() => close()).thenAnswer((_) async => {});
  }
}

void main() {
  late AuthBloc authBloc;
  late AuthService mockAuthService;
  late UserService mockUserService;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(
      const UserInitializationDTO(
        name: "name",
        email: "email",
        id: "id",
        profilePicture: "example.com",
      ),
    );
  });

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(MockAuthService());
    getIt.registerSingleton<UserService>(MockUserService());

    mockAuthService = getIt<AuthService>();
    mockUserService = getIt<UserService>();

    authBloc = MockAuthBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
  });

  tearDown(() {
    authBloc.close();
    getIt.reset();
  });

  group('GoogleSignInButton tests', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          home: Scaffold(
            body: GoogleSignInButton(
              type: AuthType.signIn,
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
            body: GoogleSignInButton(
              type: AuthType.signIn,
            ),
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
              type: AuthType.signIn,
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

    testWidgets(
        'Widget onTap callback is call Bloc Event Correctly SignUp Bloc',
        (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          AuthInitial(),
          SignUpLoading(),
          SignUpSuccess(),
        ]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => authBloc,
            child: const Scaffold(
              body: GoogleSignInButton(
                type: AuthType.signUp,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inkWellFinder = find.byType(InkWell);
      await tester.tap(inkWellFinder, warnIfMissed: false);

      await tester.pumpAndSettle();

      verify(
        () => authBloc.add(SignUpByGoogleRequest()),
      ).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets(
        'Widget onTap callback is call Bloc Event Correctly Sign In Bloc',
        (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          AuthInitial(),
          SignInLoading(),
          SignInSuccess(),
        ]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => authBloc,
            child: const Scaffold(
              body: GoogleSignInButton(
                type: AuthType.signIn,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inkWellFinder = find.byType(InkWell);
      await tester.tap(inkWellFinder, warnIfMissed: false);

      await tester.pumpAndSettle();

      verify(
        () => authBloc.add(SignInByGoogleRequest()),
      ).called(1);

      await tester.pumpAndSettle();
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
