import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthService({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> signUp(SignUpDTO dto) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );
      return _checkUserCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  Future<User> signInWithEmailAndPassword(SignInDTO dto) async {
    try {
      final UserCredential credential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      return _checkUserCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Sign in with Google failed';
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.accessToken != null && googleAuth.idToken != null) {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      return _checkUserCredential(userCredential);
    }

    throw FirebaseAuthException(
      code: 'sign_in_failed',
      message: 'Sign in failed',
    );
  }

  Future<User> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );

    final OAuthCredential oAuthCredential =
        OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
    );
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(oAuthCredential);
    return _checkUserCredential(userCredential);
  }

  User _checkUserCredential(UserCredential credential) {
    if (credential.user != null) {
      return credential.user!;
    } else {
      throw FirebaseAuthException(
          code: 'sign_in_failed', message: 'User not found');
    }
  }
}
