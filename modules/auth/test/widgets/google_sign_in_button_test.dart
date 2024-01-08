import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:networking/services/user_services.dart';

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

class MockSignInBloc extends Mock implements SignInBloc {
  @override
  final AuthService services;
  @override
  final UserService userService;

  MockSignInBloc({required this.services, required this.userService}) {
    when(() => close()).thenAnswer((_) async => {});
  }
}

class MockSignUpBloc extends Mock implements SignUpBloc {
  @override
  final AuthService services;
  @override
  final UserService userService;

  MockSignUpBloc({required this.services, required this.userService}) {
    when(() => close()).thenAnswer((_) async => {});
  }
}

void main() {
  late SignInBloc signInBloc;
  late SignUpBloc signUpBloc;
  late AuthService mockAuthService;
  late UserService mockUserService;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(
      const UserInitializationDTO(name: "name", email: "email", id: "id"),
    );
  });

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(MockAuthService());
    getIt.registerSingleton<UserService>(MockUserService());

    mockAuthService = getIt<AuthService>();
    mockUserService = getIt<UserService>();

    signInBloc = MockSignInBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
    signUpBloc = MockSignUpBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
  });

  tearDown(() {
    signInBloc.close();
    getIt.reset();
  });

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

    testWidgets(
        'Widget onTap callback is call Bloc Event Correctly SignIn Bloc',
        (WidgetTester tester) async {
      whenListen(
        signUpBloc,
        Stream.fromIterable([
          SignUpInitial(),
          SignUpLoading(),
          SignUpSuccess(),
        ]),
        initialState: SignUpInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<SignUpBloc>(
            create: (context) => signUpBloc,
            child: const Scaffold(
              body: GoogleSignInButton(
                bloc: SignUpBloc,
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
        () => signUpBloc.add(SignUpByGoogleRequest()),
      ).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets(
        'Widget onTap callback is call Bloc Event Correctly SignUp Bloc',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          SignInLoading(),
          SignInSuccess(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<SignInBloc>(
            create: (context) => signInBloc,
            child: const Scaffold(
              body: GoogleSignInButton(
                bloc: SignInBloc,
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
        () => signInBloc.add(SignInByGoogleRequest()),
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
