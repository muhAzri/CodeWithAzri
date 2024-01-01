import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:networking/services/auth_services.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignIn() {
    when(() => signIn()).thenAnswer((_) async => MockGoogleSignInAccount());
  }
}

class MockUser extends Mock implements User {}

class MockAuthService extends Mock implements AuthService {
  MockAuthService({
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

void main() {
  late SignUpBloc signUpBloc;
  late MockAuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = MockAuthService(
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

  tearDown(() {
    signUpBloc.close();
    resetMocktailState();
  });
  group("SignUp Bloc Test", () {
    const signUpDTO = SignUpDTO(
        name: "Name", email: 'example@example.com', password: '<PASSWORD>');

    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpSuccess] when SignUpRequest is added successfully',
      build: () {
        when(
          () => authService.signUp(
            signUpDTO,
          ),
        ).thenAnswer((_) async => MockUser());

        return signUpBloc;
      },
      act: (bloc) => bloc.add(const SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpFailed] when SignUpRequest is added and fails',
      build: () {
        when(
          () => authService.signUp(
            // email: "email",
            // password: "password",
            signUpDTO,
          ),
        ).thenAnswer((_) async => throw 'Sign Up Failed');

        return signUpBloc;
      },
      act: (bloc) => bloc.add(const SignUpRequest(dto: signUpDTO)),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: 'Sign Up Failed'),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpSuccess] when SignUpByGoogleRequest is added successfully',
      build: () {
        when(
          () => authService.signInWithGoogle(),
        ).thenAnswer((_) async => MockUser());

        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpFailed] when SignUpByGoogleRequest is added and fails',
      build: () {
        when(
          () => authService.signInWithGoogle(),
        ).thenAnswer((_) async => throw 'Sign Up Failed');

        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpByGoogleRequest()),
      expect: () => [
        SignUpLoading(),
        const SignUpFailed(error: 'Sign Up Failed'),
      ],
    );

    test('should initialize services with provided AuthService', () {
      final mockAuthService = authService;
      final signUpBloc = SignUpBloc(service: mockAuthService);

      expect(signUpBloc.services, equals(mockAuthService));
    });
  });
}
