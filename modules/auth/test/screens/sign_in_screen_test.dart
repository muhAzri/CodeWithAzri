import 'package:app/app.dart';
import 'package:auth/auth.dart';
import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:shared/shared.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAuthServiceImpl extends AuthServiceImpl {
  MockAuthServiceImpl({
    required super.firebaseAuth,
    required super.googleSignIn,
  });
}

class MockSignInBloc extends Mock implements SignInBloc {
  MockSignInBloc({required service}) {
    // Mock the close method to return a non-null Future.
    when(() => close()).thenAnswer((_) async {});
    // Mock any other methods you need here.
  }
}

class MockAuth extends Mock implements MockFirebaseAuth {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late SignInBloc signInBloc;
  late MockAuthServiceImpl authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockSignInBloc mockSignInBloc;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = MockAuthServiceImpl(
        firebaseAuth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);
    signInBloc = SignInBloc(service: authService);
    mockSignInBloc = MockSignInBloc(service: authService);
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
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
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
            create: (context) => newMockSignInBloc,
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
        () => newMockSignInBloc.add(
          const ForgotPasswordRequest(email: 'email@domain.com'),
        ),
      ).called(1);

      await tester.pumpAndSettle();
    });

    testWidgets('BuildSignInForms Widget Test ForgotPassword Failed',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
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
            create: (context) => newMockSignInBloc,
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
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
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
            create: (context) => newMockSignInBloc,
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
        () => newMockSignInBloc.add(
          const SignInRequest(
            signInDTO:
                SignInDTO(email: "email@domain.com", password: "password"),
          ),
        ),
      ).called(1);
    });

    testWidgets('BuildSignInButton Widget Test Empty Forms',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        LocalizationTestApp(
          child: BlocProvider<SignInBloc>(
            create: (context) => newMockSignInBloc,
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
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(0.5)),
              child: BlocProvider.value(
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
        mockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
          SignInLoading(),
          SignInSuccess(),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => mockSignInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/onboard': (_) => const Scaffold(
                    body: Center(
                      child: Text('onboarding'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      mockSignInBloc.add(
        const SignInRequest(
          signInDTO: SignInDTO(
            email: "email",
            password: "password",
          ),
        ),
      );

      await tester.pumpAndSettle();

      await mockSignInBloc.close();
    });

    testWidgets('SignInBlocListener Test Failed Test',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
          SignInLoading(),
          const SignInFailed(error: "Failed to Sign In"),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => newMockSignInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/onboard': (_) => const Scaffold(
                    body: Center(
                      child: Text('onboarding'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      mockSignInBloc.add(
        const SignInRequest(
          signInDTO: SignInDTO(
            email: "email",
            password: "password",
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to Sign In'), findsOneWidget);

      await mockSignInBloc.close();
    });

    testWidgets('SignInBlocListener Test Failed Forgot Success',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          ForgotPasswordSuccess()
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => newMockSignInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/onboard': (_) => const Scaffold(
                    body: Center(
                      child: Text('onboarding'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      mockSignInBloc.add(
        const ForgotPasswordRequest(
          email: "email",
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('resetPasswordSended'), findsOneWidget);

      await mockSignInBloc.close();
    });

    testWidgets('SignInBlocListener Test Failed Forgot Password',
        (WidgetTester tester) async {
      var newAuthService = MockAuthServiceImpl(
          firebaseAuth: MockAuth(), googleSignIn: mockGoogleSignIn);
      var newMockSignInBloc = MockSignInBloc(service: newAuthService);

      whenListen(
        newMockSignInBloc,
        Stream.fromIterable([
          SignInInitial(),
          ForgotPasswordLoading(),
          const ForgotPasswordFailed(error: "Failed to Send Email"),
        ]),
        initialState: SignInInitial(),
      );

      await tester.pumpWidget(
        BlocProvider<SignInBloc>(
          create: (context) => newMockSignInBloc,
          child: TestApp(
            routes: {
              '/': (_) => MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(0.5)),
                    child: SignInScreen(),
                  ),
              '/onboard': (_) => const Scaffold(
                    body: Center(
                      child: Text('onboarding'),
                    ),
                  )
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      mockSignInBloc.add(
        const ForgotPasswordRequest(
          email: "email",
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to Send Email'), findsOneWidget);

      await mockSignInBloc.close();
    });
  });
}
