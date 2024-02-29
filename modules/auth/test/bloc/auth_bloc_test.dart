import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/data/dto/auth/sign_in_dto.dart';
import 'package:auth/data/dto/auth/sign_up_dto.dart';
import 'package:auth/data/dto/user/user_initialization_dto.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:auth/data/remote/user_services.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  final String photoURL;

  MockUser({
    this.uid = 'id',
    this.displayName = 'name',
    this.email = 'email',
    this.photoURL = 'example.com',
  });
}

void main() {
  late AuthBloc authBloc;
  late AuthService mockAuthService;
  late UserService mockUserService;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(
      const SignInDTO(email: "email", password: "password"),
    );
    registerFallbackValue(
      const SignUpDTO(name: "name", email: "email", password: "password"),
    );
    registerFallbackValue(
      const UserInitializationDTO(
          name: "name",
          email: "email",
          id: "id",
          profilePicture: "example.com"),
    );
  });

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerSingleton<AuthService>(MockAuthService());
    getIt.registerSingleton<UserService>(MockUserService());

    mockAuthService = getIt<AuthService>();
    mockUserService = getIt<UserService>();

    authBloc = AuthBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
  });

  tearDown(() {
    authBloc.close();
    getIt.reset();
  });

  group("Auth Bloc Test Group (Sign In)", () {
    SignInDTO signInDTO = const SignInDTO(
      email: "email",
      password: "password",
    );

    test("SignInEvent instances with same type are equal", () {
      const event1 = SignInRequest(
          signInDTO: SignInDTO(email: "email", password: "password"));
      const event2 = SignInRequest(
          signInDTO: SignInDTO(email: "email", password: "password"));

      expect(event1, equals(event2));
    });

    test("SignInEvent instances with same type are not equal", () {
      const event1 = SignInRequest(
          signInDTO: SignInDTO(email: "email", password: "password"));
      final event2 = SignInByGoogleRequest();

      expect(event1, isNot(equals(event2)));
    });

    blocTest<AuthBloc, AuthState>(
      "emits [SignInLoading, SignInSuccess] when SignInRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithEmailAndPassword(any()))
            .thenAnswer(
          (_) async => MockUser(),
        );

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInRequest(signInDTO: signInDTO)),
      expect: () => [
        SignInLoading(),
        SignInSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignInLoading, SignInFailed] when signInService throws an exception",
      build: () {
        when(() => mockAuthService.signInWithEmailAndPassword(any())).thenThrow(
          FirebaseAuthException(
            message: "Failed To Sign In",
            code: '401',
          ),
        );

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInRequest(signInDTO: signInDTO)),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "[firebase_auth/401] Failed To Sign In"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenAnswer(
          (_) async => MockUser(),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        SignInSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest throws an exception",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenThrow(
          FirebaseAuthException(
            message: "Failed To Sign In",
            code: '401',
          ),
        );
        when(() => mockUserService.initializeUser(any())).thenAnswer((_) async {
          return;
        });

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "[firebase_auth/401] Failed To Sign In"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest userinitialization throws an exception",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenAnswer(
          (_) async => MockUser(),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "Internal Server Error"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [ForgotPasswordLoading,ForgotPasswordSuccess] when ForgotPasswordRequest is added successfully",
      build: () {
        when(() => mockAuthService.sendPasswordResetEmail(any()))
            .thenAnswer((_) async {
          return;
        });

        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordRequest(email: "email")),
      expect: () => [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [ForgotPasswordLoading,ForgotPasswordFailed] when ForgotPasswordRequest is failed",
      build: () {
        when(() => mockAuthService.sendPasswordResetEmail(any())).thenThrow(
          FirebaseAuthException(
            code: "401",
            message: "Failed To Send Reset Password Email",
          ),
        );

        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordRequest(email: "email")),
      expect: () => [
        ForgotPasswordLoading(),
        const ForgotPasswordFailed(
          error: "[firebase_auth/401] Failed To Send Reset Password Email",
        ),
      ],
    );
  });

  group("Auth Bloc Test Group (Sign Up)", () {
    SignUpDTO signUpDTO =
        const SignUpDTO(name: "name", email: "email", password: "password");

    test("SignUpEvent instances with same type are equal", () {
      const event1 = SignUpRequest(
          dto: SignUpDTO(name: "name", email: "email", password: "password"));
      const event2 = SignUpRequest(
          dto: SignUpDTO(name: "name", email: "email", password: "password"));

      expect(event1, equals(event2));
    });

    test("SignUpEvent instances with same type are not equal", () {
      const event1 = SignUpRequest(
          dto: SignUpDTO(name: "name", email: "email", password: "password"));
      final event2 = SignUpByGoogleRequest();

      expect(event1, isNot(equals(event2)));
    });

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpSuccess] when SignUpRequest is added successfully",
      build: () {
        when(() => mockAuthService.signUp(any()))
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any())).thenAnswer((_) async {
          return;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpFailed] when signupService throws an exception",
      build: () {
        when(() => mockAuthService.signUp(any())).thenThrow(
          FirebaseAuthException(
            code: "401",
            message: "Failed To Sign Up",
          ),
        );
        when(() => mockUserService.initializeUser(any())).thenAnswer((_) async {
          return;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(
          error: "[firebase_auth/401] Failed To Sign Up",
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpFailed] when Initialize User Service throws an exception",
      build: () {
        when(() => mockAuthService.signUp(any()))
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Internal Server Error"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpSuccess] when SignUpByGoogleRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithGoogle())
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any())).thenAnswer((_) async {
          return;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpFailed] when signInWithGoogle is Throw Error",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenThrow(
          FirebaseAuthException(
            code: "401",
            message: "Failed To Sign Up",
          ),
        );
        when(() => mockUserService.initializeUser(any())).thenAnswer((_) async {
          return;
        });
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "[firebase_auth/401] Failed To Sign Up"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [SignUpLoading, SignUpFailed] SignUpWithGoogle when Initialize User Service is Throw Error",
      build: () {
        when(() => mockAuthService.signInWithGoogle())
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Internal Server Error"),
      ],
    );
  });
}
