import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/dto/auth/sign_in_dto.dart';
import 'package:models/dto/auth/sign_up_dto.dart';
import 'package:networking/services/auth_services.dart';

class MockAuthServices extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  late AuthService mockAuthServices;
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;

    getIt.registerSingleton<AuthService>(MockAuthServices());

    mockAuthServices = getIt.get<AuthService>();
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
  });
  group(
    "Auth Service Test",
    () {
      const signInDTO = SignInDTO(email: "email", password: "password");
      const signUpDTO =
          SignUpDTO(name: "name", email: "email", password: "password");
      const email = "email@domain.com";

      test("signInWithEmailAndPassword return User When Success", () async {
        when(() => mockAuthServices.signInWithEmailAndPassword(any()))
            .thenAnswer((_) async => MockUser());

        final user =
            await mockAuthServices.signInWithEmailAndPassword(signInDTO);

        expect(user, isNotNull);
        expect(user, isA<MockUser>());
      });

      test("signInWithEmailAndPassword throws error when unsuccessful",
          () async {
        when(() => mockAuthServices.signInWithEmailAndPassword(any()))
            .thenThrow(
          FirebaseAuthException(
            code: 'wrong-password',
            message:
                'The password is invalid or the user does not have a password.',
          ),
        );

        callSignIn() async =>
            await mockAuthServices.signInWithEmailAndPassword(signInDTO);

        expect(callSignIn, throwsA(isA<FirebaseAuthException>()));
      });

      test(
        "signUp return User When Success",
        () async {
          when(() => mockAuthServices.signUp(any()))
              .thenAnswer((_) async => MockUser());

          final user = await mockAuthServices.signUp(signUpDTO);

          expect(user, isNotNull);
          expect(user, isA<MockUser>());
        },
      );

      test(
        "signUp throws error when unsuccessful",
        () async {
          when(() => mockAuthServices.signUp(any())).thenThrow(
            FirebaseAuthException(
              code: 'email-already-in-use',
              message: 'Email address is already in use by another account.',
            ),
          );

          callSignUp() async => await mockAuthServices.signUp(signUpDTO);

          expect(callSignUp, throwsA(isA<FirebaseAuthException>()));
        },
      );

      test(
        "sendPasswordResetEmail completes successfully",
        () async {
          when(() => mockAuthServices.sendPasswordResetEmail(email))
              .thenAnswer((_) async {});

          callSendPasswordResetEmail() async =>
              await mockAuthServices.sendPasswordResetEmail(email);

          await expectLater(callSendPasswordResetEmail(), completes);
        },
      );

      test(
        "sendPasswordResetEmail throws FirebaseAuthException for invalid email",
        () async {
          when(() => mockAuthServices.sendPasswordResetEmail(email)).thenThrow(
              FirebaseAuthException(
                  code: 'user-not-found',
                  message:
                      'There is no user corresponding to the given email.'));

          callSendPasswordResetEmail() async =>
              await mockAuthServices.sendPasswordResetEmail(email);

          expect(
            callSendPasswordResetEmail,
            throwsA(isA<FirebaseAuthException>()),
          );
        },
      );

      test(
        "signOut completes successfully",
        () async {
          when(() => mockAuthServices.signOut()).thenAnswer((_) async {});

          callSignOut() async => await mockAuthServices.signOut();

          await expectLater(callSignOut(), completes);
        },
      );

      test(
        "signOut throws FirebaseAuthException when an error occurs",
        () async {
          when(() => mockAuthServices.signOut()).thenThrow(
              FirebaseAuthException(
                  code: 'sign-out-error',
                  message: 'An error occurred during sign-out.'));

          callSignOut() async => await mockAuthServices.signOut();

          expect(callSignOut, throwsA(isA<FirebaseAuthException>()));
        },
      );

      test("signInWithGoogle return User when SuccessFull", () async {
        when(() => mockAuthServices.signInWithGoogle())
            .thenAnswer((_) async => MockUser());

        final user = await mockAuthServices.signInWithGoogle();

        expect(user, isNotNull);
        expect(user, isA<MockUser>());
      });

      test("signInWithGoogle throw FirebaseAuthException when UnsuccessFull",
          () async {
        when(() => mockAuthServices.signInWithGoogle()).thenThrow(
          FirebaseAuthException(
            code: 'sign_in_failed',
            message: 'Sign in failed',
          ),
        );
        callGoogleSignIn() async => await mockAuthServices.signInWithGoogle();

        expect(callGoogleSignIn, throwsA(isA<FirebaseAuthException>()));
      });

      test("signInWithApple return User when SuccessFull", () async {
        when(() => mockAuthServices.signInWithApple())
            .thenAnswer((_) async => MockUser());

        final user = await mockAuthServices.signInWithApple();

        expect(user, isNotNull);
        expect(user, isA<MockUser>());
      });

      test("signInWithApple throw FirebaseAuthException when UnsuccessFull",
          () async {
        when(() => mockAuthServices.signInWithApple()).thenThrow(
          FirebaseAuthException(
            code: 'sign_in_failed',
            message: 'Sign in failed',
          ),
        );
        callAppleSignIn() async => await mockAuthServices.signInWithApple();

        expect(callAppleSignIn, throwsA(isA<FirebaseAuthException>()));
      });

      test("authStateChanges emits user when signed in", () async {
        final mockUser = MockUser();
        final expectedUser = mockUser;
        when(() => mockAuthServices.authStateChanges)
            .thenAnswer((_) => Stream<User?>.value(mockUser));

        final Stream<User?> stream = mockAuthServices.authStateChanges;

        final user = await stream.firstWhere((user) => user != null);
        expect(user, equals(expectedUser));
      });

      test("authStateChanges emits null by default", () async {
        when(() => mockAuthServices.authStateChanges)
            .thenAnswer((_) => Stream<User?>.value(null));

        final Stream<User?> stream = mockAuthServices.authStateChanges;

        final user = await stream.firstWhere((user) => user == null);
        expect(user, isNull);
      });
    },
  );
}
