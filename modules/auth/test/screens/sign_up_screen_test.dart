import 'package:app/presentation/widgets/custom_textform_field.dart';
import 'package:auth/auth.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:cwa_core/test_helper/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

enum NavigatorAction { push, pop, replaced }

class MockNavigatorObserver extends NavigatorObserver {
  final List<NavigatorAction> history = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(NavigatorAction.push);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    history.add(NavigatorAction.replaced);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
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
      const SignUpDTO(name: "name", email: "email", password: "password"),
    );
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

  group('SignUpScreen Widgets Test', () {
    testWidgets('BuildSignUpHeader Widget Test', (WidgetTester tester) async {
      await tester
          .pumpWidget(const LocalizationTestApp(child: BuildSignUpHeader()));

      await tester.pumpAndSettle();

      expect(find.text('signUpWelcomeMessage'), findsOneWidget);
      expect(find.text('signUpSubtitle'), findsOneWidget);
    });

    testWidgets('BuildSignUpForms Widget Test', (WidgetTester tester) async {
      bool initialObscureText = true;

      await tester
          .pumpWidget(const TestApp(home: Material(child: BuildSignUpForms())));
      expect(find.byType(CustomTextFormField), findsNWidgets(3));

      final signUpFormsState = tester.state<BuildSignUpFormsState>(
        find.byType(BuildSignUpForms),
      );

      expect(signUpFormsState.isObsecured, initialObscureText);

      await tester.tap(
          find.descendant(
            of: find.byType(CustomTextFormField),
            matching: find.byType(InkWell),
          ),
          warnIfMissed: false);

      await tester.pump();
      await tester.pump();

      expect(signUpFormsState.isObsecured, !initialObscureText);
    });

    testWidgets('BuildSignUpButton Widget Test', (WidgetTester tester) async {
      TextEditingController nameController = TextEditingController(text: "");
      TextEditingController emailController = TextEditingController(text: "");
      TextEditingController passwordController =
          TextEditingController(text: "");

      await tester.pumpWidget(
        LocalizationTestApp(
          child: Material(
            child: BuildSignUpButton(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('signUpButtonLabel'), findsOneWidget);
    });

    testWidgets('BuildSignUpButton Widget Test Tapped Forms Filled',
        (WidgetTester tester) async {
      TextEditingController nameController =
          TextEditingController(text: "Name");
      TextEditingController emailController =
          TextEditingController(text: "Email");
      TextEditingController passwordController =
          TextEditingController(text: "Password");

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
        LocalizationTestApp(
          child: BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: Builder(builder: (context) {
              return Material(
                child: BuildSignUpButton(
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                ),
              );
            }),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('signUpButtonLabel'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell), warnIfMissed: false);

      await tester.pumpAndSettle();

      verify(
        () => authBloc.add(
          const SignUpRequest(
            dto: SignUpDTO(
              name: "Name",
              email: "Email",
              password: "Password",
            ),
          ),
        ),
      ).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets('BuildSignUpButton Widget Test Tapped Forms Empty',
        (WidgetTester tester) async {
      TextEditingController nameController = TextEditingController(text: "");
      TextEditingController emailController = TextEditingController(text: "");
      TextEditingController passwordController =
          TextEditingController(text: "");

      await tester.pumpWidget(
        LocalizationTestApp(
          child: BlocProvider<AuthBloc>(
            create: (context) => authBloc,
            child: Builder(builder: (context) {
              return Material(
                child: BuildSignUpButton(
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                ),
              );
            }),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('signUpButtonLabel'), findsOneWidget);

      await tester.tap(find.text('signUpButtonLabel'), warnIfMissed: false);

      await tester.pumpAndSettle();

      expect(find.text('formsEmptyMessage'), findsOneWidget);
    });

    testWidgets('BuildHaveAccountButton Widget Test',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        LocalizationTestApp(navigatorObservers: [
          mockObserver
        ], routes: {
          '/': (_) => Material(
                child: MediaQuery(
                  data:
                      const MediaQueryData(textScaler: TextScaler.linear(0.5)),
                  child: Builder(builder: (context) {
                    return const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: BuildHaveAccountButton(),
                    );
                  }),
                ),
              ),
          '/sign-in': (_) => const Scaffold(
                body: Center(
                  child: Text("Sign In"),
                ),
              )
        }),
      );

      await tester.pumpAndSettle();

      expect(find.text('alreadyHaveAnAccountText'), findsOneWidget);
      expect(find.text('signInButtonLabel'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell), warnIfMissed: false);

      await tester.pumpAndSettle();

      expect(mockObserver.history.contains(NavigatorAction.replaced), isTrue);
    });

    testWidgets('OrDividerWidget Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp(home: OrDividerWidget()));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('SignUp BlocListener Test', (WidgetTester tester) async {
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
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: TestApp(
            routes: {
              '/': (_) => const MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(0.5)),
                    child: SignUpScreen(),
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

      authBloc.add(
        const SignUpRequest(
          dto: SignUpDTO(
            email: "email",
            password: "password",
            name: 'name',
          ),
        ),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('SignUp BlocListener Test When Failed Occured',
        (WidgetTester tester) async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          AuthInitial(),
          SignUpLoading(),
          const SignUpFailed(error: "Failed occured"),
        ]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: TestApp(
            routes: {
              '/': (_) => const MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(0.5)),
                    child: SignUpScreen(),
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

      authBloc.add(
        const SignUpRequest(
          dto: SignUpDTO(
            email: "email",
            password: "password",
            name: 'name',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed occured'), findsOneWidget);
    });
  });
}
