import 'package:app/presentation/widgets/custom_text_button.dart';
import 'package:app/presentation/widgets/custom_textform_field.dart';
import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:auth/presentation/screens/sign_in_screen.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:networking/services/user_services.dart';
import 'package:shared/test_assets/localization_test_app.dart';
import 'package:shared/test_assets/test_app.dart';

enum NavigatorAction { push, pop }

class MockNavigatorObserver extends NavigatorObserver {
  final List<NavigatorAction> history = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(NavigatorAction.push);
    super.didPush(route, previousRoute);
  }
}

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

void main() {
  late SignInBloc signInBloc;
  late AuthService mockAuthService;
  late UserService mockUserService;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(
      const SignInDTO(email: "email", password: "password"),
    );
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
  });

  tearDown(() {
    signInBloc.close();
    getIt.reset();
  });
  group('SignInScreen Widgets Test', () {
    testWidgets('BuildSignInHeader Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const LocalizationTestApp(
          child: BuildSignInHeader(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('signInWelcomeMessage'), findsOneWidget);
      expect(find.text('signInSubtitle'), findsOneWidget);
    });

    testWidgets('BuildSignInForms Widget Test', (WidgetTester tester) async {
      bool initialObscureText = true;

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

      final signInFormsState = tester.state<BuildSignInFormsState>(
        find.byType(BuildSignInForms),
      );

      expect(signInFormsState.isObsecured, initialObscureText);

      await tester.tap(
          find.descendant(
            of: find.byType(CustomTextFormField),
            matching: find.byType(InkWell),
          ),
          warnIfMissed: false);

      await tester.pump();
      await tester.pump();

      expect(signInFormsState.isObsecured, !initialObscureText);
    });

    testWidgets('BuildSignInForms Widget Test ForgotPassword Success',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          ForgotPasswordSuccess(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider<SignInBloc>(
            create: (context) => signInBloc,
            child: const Material(
              child: BuildSignInForms(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      Finder firstCustomTextFormField = find.byType(CustomTextFormField).first;

      await tester.enterText(firstCustomTextFormField, 'email@domain.com');

      await tester.pumpAndSettle();

      await tester.tap(find.text('forgotPasswordText'), warnIfMissed: false);

      verify(
        () => signInBloc.add(
          const ForgotPasswordRequest(email: 'email@domain.com'),
        ),
      ).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets('BuildSignInForms Widget Test ForgotPassword Failed',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          const ForgotPasswordFailed(error: "Please emailHintText"),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: BlocProvider(
            create: (context) => signInBloc,
            child: const Material(
              child: BuildSignInForms(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('forgotPasswordText'), warnIfMissed: false);

      await tester.pumpAndSettle();
    });

    testWidgets('BuildSignInButton Widget Test', (WidgetTester tester) async {
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
        LocalizationTestApp(
          child: BlocProvider<SignInBloc>(
            create: (context) => signInBloc,
            child: Builder(
              builder: (context) {
                return Material(
                  child: BuildSignInButton(
                    emailController:
                        TextEditingController(text: 'email@domain.com'),
                    passwordController: TextEditingController(text: 'password'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('signInButtonLabel'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell), warnIfMissed: false);

      verify(
        () => signInBloc.add(
          const SignInRequest(
            signInDTO:
                SignInDTO(email: "email@domain.com", password: "password"),
          ),
        ),
      ).called(1);
    });

    testWidgets('BuildSignInButton Widget Test Empty Forms',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        LocalizationTestApp(
          child: BlocProvider<SignInBloc>(
            create: (context) => signInBloc,
            child: Builder(
              builder: (context) {
                return Material(
                  child: BuildSignInButton(
                    emailController: TextEditingController(text: ''),
                    passwordController: TextEditingController(text: ''),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('signInButtonLabel'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell), warnIfMissed: false);

      await tester.pumpAndSettle();

      expect(find.text('formsEmptyMessage'), findsOneWidget);
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
      expect(find.text('dontHaveAnAccountText'), findsOneWidget);
      expect(find.text('signUpButtonLabel'), findsOneWidget);
    });

    testWidgets('SignInScreen Widget Test', (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        TestApp(
          home: Material(
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
              child: BlocProvider<SignInBloc>.value(
                value: signInBloc,
                child: SignInScreen(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('SignInBlocListener Test', (WidgetTester tester) async {
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
        BlocProvider<SignInBloc>(
          create: (context) => signInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/main': (_) => const Scaffold(
                    body: Center(
                      child: Text('main'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      signInBloc.add(
        const SignInRequest(
          signInDTO: SignInDTO(
            email: "email",
            password: "password",
          ),
        ),
      );
    });

    testWidgets('SignInBlocListener Test Failed Test',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          SignInLoading(),
          const SignInFailed(error: "Failed to Sign In"),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => signInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/main': (_) => const Scaffold(
                    body: Center(
                      child: Text('main'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      signInBloc.add(
        const SignInRequest(
          signInDTO: SignInDTO(
            email: "email",
            password: "password",
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to Sign In'), findsOneWidget);
    });

    testWidgets('SignInBlocListener Test Failed Forgot Success',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          ForgotPasswordSuccess()
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => signInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/main': (_) => const Scaffold(
                    body: Center(
                      child: Text('main'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      signInBloc.add(
        const ForgotPasswordRequest(
          email: "email",
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('resetPasswordSended'), findsOneWidget);
    });

    testWidgets('SignInBlocListener Test Failed Forgot Password',
        (WidgetTester tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          const ForgotPasswordFailed(error: "Failed to Send Email"),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => signInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/main': (_) => const Scaffold(
                    body: Center(
                      child: Text('main'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      signInBloc.add(
        const ForgotPasswordRequest(
          email: "email",
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to Send Email'), findsOneWidget);
    });
  });
}
