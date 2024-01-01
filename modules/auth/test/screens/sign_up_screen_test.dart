import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:shared/shared.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignIn() {
    when(() => signIn()).thenAnswer((_) async => MockGoogleSignInAccount());
  }
}

class MockUser extends Mock implements User {}

class MockAuthServiceImpl extends Mock implements AuthServiceImpl {
  MockAuthServiceImpl({
    required firebaseAuth,
    required googleSignIn,
  }) {
    when(() => signUp(any())).thenAnswer((_) async => MockUser());
  }
}

class MockSignUpBloc extends Mock implements SignUpBloc {
  MockSignUpBloc({required service});
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuth extends Mock implements MockFirebaseAuth {}

class MockBuildContext extends Mock implements BuildContext {}

enum NavigatorAction { push, pop }

class MockNavigatorObserver extends NavigatorObserver {
  final List<NavigatorAction> history = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    history.add(NavigatorAction.push);
    super.didPush(route, previousRoute);
  }
}

void main() {
  late SignUpBloc signUpBloc;
  late MockAuthServiceImpl authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = MockAuthServiceImpl(
        firebaseAuth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);

    signUpBloc = SignUpBloc(service: authService);
  });

  setUpAll(() {
    registerFallbackValue(
      const SignUpDTO(
        name: "Name",
        email: 'example@example.com',
        password: '<PASSWORD>',
      ),
    );
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

      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignUpBloc = MockSignUpBloc(service: newAuthService);

      whenListen(
        newMockSignUpBloc,
        Stream.fromIterable([
          SignUpInitial(),
          SignUpLoading(),
          SignUpSuccess(),
        ]),
        initialState: SignUpInitial(),
      );

      await tester.pumpWidget(
        LocalizationTestApp(
          child: BlocProvider<SignUpBloc>.value(
            value: newMockSignUpBloc,
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
        () => newMockSignUpBloc.add(
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
          child: BlocProvider<SignUpBloc>(
            create: (context) => signUpBloc,
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
        LocalizationTestApp(
          navigatorObservers: [mockObserver],
          child: Material(
            child: Builder(builder: (context) {
              return const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BuildHaveAccountButton(),
              );
            }),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('alreadyHaveAnAccountText'), findsOneWidget);
      expect(find.text('signInButtonLabel'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell), warnIfMissed: false);

      await tester.pumpAndSettle();

      expect(mockObserver.history.contains(NavigatorAction.push), isTrue);
    });

    testWidgets('OrDividerWidget Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TestApp(home: OrDividerWidget()));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('SignUpScreen Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MediaQuery(
              // Shrink the text avoid overflow caused by large Ahem font.
              data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
              child: BlocProvider.value(
                value: signUpBloc,
                child: const SignUpScreen(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('SignUp BlocListener Test', (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignUpBloc = MockSignUpBloc(service: newAuthService);

      whenListen(
        newMockSignUpBloc,
        Stream.fromIterable([
          SignUpInitial(),
          SignUpLoading(),
          SignUpSuccess(),
        ]),
        initialState: SignUpInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignUpBloc>.value(
          value: newMockSignUpBloc,
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

      newMockSignUpBloc.add(
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
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignUpBloc = MockSignUpBloc(service: newAuthService);

      whenListen(
        newMockSignUpBloc,
        Stream.fromIterable([
          SignUpInitial(),
          SignUpLoading(),
          const SignUpFailed(error: "Failed occured"),
        ]),
        initialState: SignUpInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignUpBloc>.value(
          value: newMockSignUpBloc,
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

      newMockSignUpBloc.add(
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
