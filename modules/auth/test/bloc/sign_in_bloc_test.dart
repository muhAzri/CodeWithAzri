import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:networking/services/auth_services.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAuthServiceImpl extends AuthServiceImpl {
  MockAuthServiceImpl({
    required super.firebaseAuth,
    required super.googleSignIn,
  });
}

void main() {
  late SignInBloc signInBloc;
  late MockAuthServiceImpl authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = MockAuthServiceImpl(
        firebaseAuth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);
    signInBloc = SignInBloc(service: authService);
  });

  tearDown(() {
    signInBloc.close();
    resetMocktailState();
  });

  group('SignInBloc', () {
    const signInDTO =
        SignInDTO(email: 'example@example.com', password: '<PASSWORD>');
    const email = 'example@example.com';

    blocTest<SignInBloc, SignInState>(
      'emits [SignInLoading, SignInSuccess] when SignInRequest is added successfully',
      build: () {
        when(() async => await mockFirebaseAuth.signInWithEmailAndPassword(
              email: signInDTO.email,
              password: signInDTO.password,
            ));

        return signInBloc;
      },
      act: (bloc) => bloc.add(const SignInRequest(signInDTO: signInDTO)),
      expect: () => [
        SignInLoading(),
        SignInSuccess(),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'emits [ForgotPasswordLoading, ForgotPasswordSuccess] when ForgotPasswordRequest is added successfully',
      build: () {
        when(() async =>
            await mockFirebaseAuth.sendPasswordResetEmail(email: email));
        return signInBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordRequest(email: email)),
      expect: () => [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(),
      ],
    );
  });
}
