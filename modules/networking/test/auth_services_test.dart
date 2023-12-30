// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:models/DTO/auth/sign_in_dto.dart';
// import 'package:models/DTO/auth/sign_up_dto.dart';
// import 'package:networking/services/auth_services.dart';

// class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  // late AuthServiceImpl authService;
  // late MockFirebaseAuth mockFirebaseAuth;
  // late MockGoogleSignIn mockGoogleSignIn;

  // setUp(() {
  //   mockFirebaseAuth = MockFirebaseAuth();
  //   mockGoogleSignIn = MockGoogleSignIn();
  //   authService = AuthServiceImpl(
  //       firebaseAuth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);
  // });

  // group('Sign Up Tests', () {
  //   test('Successful Sign Up', () async {
  //     const signUpDto = SignUpDTO(
  //       email: 'test@example.com',
  //       password: 'password123',
  //       name: 'Test',
  //     );

  //     final result = await authService.signUp(signUpDto);
  //     expect(result, isA<MockUser>());
  //   });
  // });

  // group('Sign In Tests', () {
  //   test("Successful Sign In", () async {
  //     const signInDTO = SignInDTO(
  //       email: 'test@example.com',
  //       password: 'password123',
  //     );

  //     final result = await authService.signInWithEmailAndPassword(signInDTO);
  //     expect(result, isA<MockUser>());
  //   });
  // });

  // group('Sign Out Tests', () {
  //   test('Successful Sign Out', () async {
  //     // Sign in a user to perform sign-out
  //     const signInDTO = SignInDTO(
  //       email: 'test@example.com',
  //       password: 'password123',
  //     );

  //     await authService.signInWithEmailAndPassword(signInDTO);

  //     expect(authService.isLoggedIn(), isTrue);

  //     await authService.signOut();

  //     expect(authService.isLoggedIn(), isFalse);
  //   });
  // });

  // group('Google Sign In Tests', () {
  //   // Test Google sign-in functionality
  // });

  // group('Apple Sign In Tests', () {
  //   // Test Apple sign-in functionality
  // });
}
