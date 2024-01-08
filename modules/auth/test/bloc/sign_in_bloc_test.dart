import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
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

    signInBloc = SignInBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
  });

  tearDown(() {
    signInBloc.close();
    getIt.reset();
  });

  group("Sign In Bloc Test", () {
    SignInDTO signInDTO = const SignInDTO(
      email: "email",
      password: "password",
    );

    blocTest(
      "emits [SignInLoading, SignInSuccess] when SignInRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithEmailAndPassword(any()))
            .thenAnswer(
          (_) async => MockUser(),
        );

        return signInBloc;
      },
      act: (bloc) => bloc.add(SignInRequest(signInDTO: signInDTO)),
      expect: () => [
        SignInLoading(),
        SignInSuccess(),
      ],
    );

    blocTest(
      "emits [SignInLoading, SignInFailed] when signInService throws an exception",
      build: () {
        when(() => mockAuthService.signInWithEmailAndPassword(any())).thenThrow(
          FirebaseException(
            plugin: "FirebaseAuthException",
            message: "Failed To Sign In",
          ),
        );

        return signInBloc;
      },
      act: (bloc) => bloc.add(SignInRequest(signInDTO: signInDTO)),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "Failed To Sign In"),
      ],
    );

    blocTest(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenAnswer(
          (_) async => MockUser(),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});

        return signInBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        SignInSuccess(),
      ],
    );

    blocTest(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest throws an exception",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenThrow(
          FirebaseException(
            plugin: "FirebaseAuthException",
            message: "Failed To Sign In",
          ),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});

        return signInBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "Failed To Sign In"),
      ],
    );

    blocTest(
      "emits [SignInLoading, SignInSuccess] when SignInByGoogleRequest userinitialization throws an exception",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenAnswer(
          (_) async => MockUser(),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");

        return signInBloc;
      },
      act: (bloc) => bloc.add(SignInByGoogleRequest()),
      expect: () => [
        SignInLoading(),
        const SignInFailed(error: "Internal Server Error"),
      ],
    );

    blocTest(
      "emits [ForgotPasswordLoading,ForgotPasswordSuccess] when ForgotPasswordRequest is added successfully",
      build: () {
        when(() => mockAuthService.sendPasswordResetEmail(any()))
            .thenAnswer((_) async {});

        return signInBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordRequest(email: "email")),
      expect: () => [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(),
      ],
    );

    blocTest(
      "emits [ForgotPasswordLoading,ForgotPasswordFailed] when ForgotPasswordRequest is failed",
      build: () {
        when(() => mockAuthService.sendPasswordResetEmail(any())).thenThrow(
          FirebaseException(
            plugin: "FirebaseAuthException",
            message: "Failed To Send Reset Password Email",
          ),
        );

        return signInBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordRequest(email: "email")),
      expect: () => [
        ForgotPasswordLoading(),
        const ForgotPasswordFailed(
          error: "Failed To Send Reset Password Email",
        ),
      ],
    );
  });
}
