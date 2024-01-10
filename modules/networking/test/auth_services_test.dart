import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/dto/auth/sign_in_dto.dart';
import 'package:models/dto/auth/sign_up_dto.dart';
import 'package:networking/services/apple_sign_in_service.dart';
import 'package:networking/services/auth_services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {
  @override
  final User? user;

  MockUserCredential({this.user});
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockAppleSignInService extends Mock implements AppleSignInService {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  final Future<GoogleSignInAuthentication> authentication;

  MockGoogleSignInAccount(
      {Future<GoogleSignInAuthentication>? newAuthentication})
      : authentication =
            newAuthentication ?? Future.value(MockGoogleSignInAuthentication());
}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {
  @override
  final String? accessToken;
  @override
  final String? idToken;

  MockGoogleSignInAuthentication({
    this.accessToken = 'token',
    this.idToken = 'idToken',
  });
}

class MockAuthorizationCredentialAppleID extends Mock
    implements AuthorizationCredentialAppleID {}

void main() {
  late AuthService mockAuthServices;
  late FirebaseAuth mockFirebaseAuth;
  late GoogleSignIn mockGoogleSignIn;
  late AppleSignInService mockAppleSignInService;
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerSingleton<FirebaseAuth>(MockFirebaseAuth());
    getIt.registerSingleton<GoogleSignIn>(MockGoogleSignIn());
    getIt.registerSingleton<AppleSignInService>(MockAppleSignInService());

    getIt.registerFactory<AuthService>(
      () => AuthService(
        firebaseAuth: getIt.get<FirebaseAuth>(),
        googleSignIn: getIt.get<GoogleSignIn>(),
        appleSignInService: getIt.get<AppleSignInService>(),
      ),
    );

    mockFirebaseAuth = getIt.get<FirebaseAuth>();
    mockGoogleSignIn = getIt.get<GoogleSignIn>();
    mockAuthServices = getIt.get<AuthService>();
    mockAppleSignInService = getIt.get<AppleSignInService>();
  });

  tearDown(() {
    getIt.reset();
  });

  setUpAll(() {
    registerFallbackValue(
      const SignInDTO(email: "email", password: "password"),
    );
    registerFallbackValue(
      const SignUpDTO(name: "name", email: "email", password: "password"),
    );
    registerFallbackValue(MockUserCredential(user: MockUser()));
    registerFallbackValue(const AuthCredential(
      providerId: 'providerId',
      signInMethod: 'signInMethod',
    ));
  });
  group(
    "Auth Service Test",
    () {
      const signInDTO = SignInDTO(email: "email", password: "password");
      const signUpDTO =
          SignUpDTO(name: "name", email: "email", password: "password");
      const email = "email@domain.com";

      test("signInWithEmailAndPassword return User When Success", () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: "email"),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async => MockUserCredential(
            user: MockUser(),
          ),
        );

        final user =
            await mockAuthServices.signInWithEmailAndPassword(signInDTO);

        expect(user, isA<User>());
        expect(user, isNotNull);
      });

      test("signInWithEmailAndPassword throws error when unsuccessful",
          () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: "email"),
              password: any(named: 'password'),
            )).thenThrow(
          FirebaseAuthException(
            code: 'wrong-password',
            message:
                'The password is invalid or the user does not have a password.',
          ),
        );

        callSignIn() async =>
            await mockAuthServices.signInWithEmailAndPassword(signInDTO);

        expect(
          callSignIn,
          throwsA(
            isA<String>().having(
              (e) => e,
              'message',
              'The password is invalid or the user does not have a password.',
            ),
          ),
        );
      });

      test(
        "signUp return User When Success",
        () async {
          when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
                email: any(named: "email"),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => MockUserCredential(
              user: MockUser(),
            ),
          );

          final user = await mockAuthServices.signUp(signUpDTO);

          expect(user, isNotNull);
          expect(user, isA<MockUser>());
        },
      );

      test(
        "signUp throws error when unsuccessful",
        () async {
          when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
                email: any(named: "email"),
                password: any(named: 'password'),
              )).thenThrow(
            FirebaseAuthException(
              code: 'email-already-in-use',
              message: 'Email address is already in use by another account.',
            ),
          );

          callSignUp() async => await mockAuthServices.signUp(signUpDTO);

          expect(
              callSignUp,
              throwsA(
                isA<String>().having(
                  (e) => e,
                  'message',
                  'Email address is already in use by another account.',
                ),
              ));
        },
      );

      test(
        "sendPasswordResetEmail completes successfully",
        () async {
          when(() => mockFirebaseAuth.sendPasswordResetEmail(
              email: any(named: 'email'))).thenAnswer((_) async {});

          callSendPasswordResetEmail() async =>
              await mockAuthServices.sendPasswordResetEmail(email);

          await expectLater(callSendPasswordResetEmail(), completes);
        },
      );

      test(
        "sendPasswordResetEmail throws FirebaseAuthException for invalid email",
        () async {
          when(
            () => mockFirebaseAuth.sendPasswordResetEmail(
              email: any(
                named: 'email',
              ),
            ),
          ).thenThrow(FirebaseAuthException(
              code: 'user-not-found',
              message: 'There is no user corresponding to the given email.'));

          callSendPasswordResetEmail() async =>
              await mockAuthServices.sendPasswordResetEmail(email);

          expect(
            callSendPasswordResetEmail,
            throwsA(
              isA<String>().having(
                (e) => e,
                'message',
                'There is no user corresponding to the given email.',
              ),
            ),
          );
        },
      );

      test(
        "signOut completes successfully",
        () async {
          when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

          callSignOut() async => await mockAuthServices.signOut();

          await expectLater(callSignOut(), completes);
        },
      );

      test(
        "signOut throws FirebaseAuthException when an error occurs",
        () async {
          when(() => mockFirebaseAuth.signOut()).thenThrow(
            FirebaseAuthException(
              code: 'sign-out-error',
              message: 'An error occurred during sign-out.',
            ),
          );

          callSignOut() async => await mockAuthServices.signOut();

          expect(
            callSignOut,
            throwsA(
              isA<String>().having(
                (e) => e,
                'message',
                'An error occurred during sign-out.',
              ),
            ),
          );
        },
      );

      test("signInWithGoogle return User when SuccessFull", () async {
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => MockGoogleSignInAccount());

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer(
          (_) async => MockUserCredential(
            user: MockUser(),
          ),
        );

        final user = await mockAuthServices.signInWithGoogle();

        expect(user, isNotNull);
        expect(user, isA<MockUser>());
      });

      test("signInWithGoogle throw FirebaseAuthException when User Not Found",
          () async {
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => MockGoogleSignInAccount());

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer(
          (_) async => MockUserCredential(),
        );

        callGoogleSignIn() async => await mockAuthServices.signInWithGoogle();
        expect(
          callGoogleSignIn,
          throwsA(
            isA<String>().having(
              (e) => e,
              'message',
              'User not found',
            ),
          ),
        );
      });

      test(
          "signInWithGoogle throw FirebaseAuthException when   Google accessToken and idToken are null",
          () async {
        when(() => mockGoogleSignIn.signIn()).thenAnswer(
          (_) async => MockGoogleSignInAccount(
            newAuthentication: Future.value(
              MockGoogleSignInAuthentication(
                accessToken: null,
                idToken: null,
              ),
            ),
          ),
        );

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer(
          (_) async => MockUserCredential(),
        );

        callGoogleSignIn() async => await mockAuthServices.signInWithGoogle();
        expect(
          callGoogleSignIn,
          throwsA(
            isA<String>().having(
              (e) => e,
              'message',
              'Sign in failed',
            ),
          ),
        );
      });

      test("signInWithGoogle throw FirebaseAuthException when UnsuccessFull",
          () async {
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => MockGoogleSignInAccount());

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenThrow(
          FirebaseAuthException(
            code: 'sign_in_failed',
            message: 'Sign in failed',
          ),
        );

        callGoogleSignIn() async => await mockAuthServices.signInWithGoogle();

        expect(
          callGoogleSignIn,
          throwsA(
            isA<String>().having(
              (e) => e,
              'message',
              'Sign in failed',
            ),
          ),
        );
      });

      test("signInWithApple return User when SuccessFull", () async {
        when(
          () => mockAppleSignInService.getAppleIDCredential(
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer((_) async => MockAuthorizationCredentialAppleID());

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer(
          (_) async => MockUserCredential(
            user: MockUser(),
          ),
        );

        final user = await mockAuthServices.signInWithApple();

        expect(user, isNotNull);
        expect(user, isA<MockUser>());
      });

      test("signInWithApple throw FirebaseAuthException when UnsuccessFull",
          () async {
        when(
          () => mockAppleSignInService.getAppleIDCredential(
            scopes: any(named: 'scopes'),
          ),
        ).thenAnswer((_) async => MockAuthorizationCredentialAppleID());

        when(() => mockFirebaseAuth.signInWithCredential(any())).thenThrow(
          FirebaseAuthException(
            code: 'sign_in_failed',
            message: 'Sign in failed',
          ),
        );

        callAppleSignIn() async => await mockAuthServices.signInWithApple();

        expect(
          callAppleSignIn,
          throwsA(
            isA<String>().having(
              (e) => e,
              'message',
              'Sign in failed',
            ),
          ),
        );
      });

      test("authStateChanges emits user when signed in", () async {
        final mockUser = MockUser();
        final expectedUser = mockUser;
        final Stream<User?> iterableStream =
            Stream<User?>.fromIterable([mockUser]);

        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => iterableStream);

        final Stream<User?> stream = mockAuthServices.authStateChanges;

        final user = await stream.firstWhere((user) => user != null);
        expect(user, equals(expectedUser));
      });

      test("authStateChanges emits null by default", () async {
        final Stream<User?> iterableStream = Stream<User?>.fromIterable([null]);

        when(mockFirebaseAuth.authStateChanges)
            .thenAnswer((_) => iterableStream);

        final Stream<User?> stream = mockAuthServices.authStateChanges;

        final user = await stream.firstWhere((user) => user == null);
        expect(user, isNull);
      });
    },
  );
}
