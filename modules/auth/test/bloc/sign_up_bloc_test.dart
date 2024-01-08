import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:networking/services/user_services.dart';

class MockAuthService extends Mock implements AuthService {}

// Mock UserService
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
  late SignUpBloc signUpBloc;
  late AuthService mockAuthService;
  late UserService mockUserService;
  late GetIt getIt;

  setUpAll(() {
    registerFallbackValue(
      const SignUpDTO(name: "name", email: "email", password: "password"),
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

    signUpBloc = SignUpBloc(
      services: mockAuthService,
      userService: mockUserService,
    );
  });

  tearDown(() {
    signUpBloc.close();
    getIt.reset();
  });

  group("Sign Up Bloc Test", () {
    SignUpDTO signUpDTO =
        const SignUpDTO(name: "name", email: "email", password: "password");

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpSuccess] when SignUpRequest is added successfully",
      build: () {
        when(() => mockAuthService.signUp(any()))
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpFailed] when signupService throws an exception",
      build: () {
        when(() => mockAuthService.signUp(any())).thenThrow(
          FirebaseException(
            plugin: "FirebaseAuthException",
            message: "Failed To Sign Up",
          ),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Failed To Sign Up"),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpFailed] when Initialize User Service throws an exception",
      build: () {
        when(() => mockAuthService.signUp(any()))
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Internal Server Error"),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpSuccess] when SignUpByGoogleRequest is added successfully",
      build: () {
        when(() => mockAuthService.signInWithGoogle())
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpFailed] when signInWithGoogle is Throw Error",
      build: () {
        when(() => mockAuthService.signInWithGoogle()).thenThrow(
          FirebaseException(
            plugin: "FirebaseAuthException",
            message: "Failed To Sign Up",
          ),
        );
        when(() => mockUserService.initializeUser(any()))
            .thenAnswer((_) async {});
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Failed To Sign Up"),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      "emits [SignUpLoading, SignUpFailed] SignUpWithGoogle when Initialize User Service is Throw Error",
      build: () {
        when(() => mockAuthService.signInWithGoogle())
            .thenAnswer((_) async => MockUser());
        when(() => mockUserService.initializeUser(any()))
            .thenThrow("Internal Server Error");
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: "Internal Server Error"),
      ],
    );
  });
}
