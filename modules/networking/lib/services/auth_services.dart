import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models/dto/auth/sign_in_dto.dart';
import 'package:models/dto/auth/sign_up_dto.dart';
import 'package:networking/services/apple_sign_in_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final AppleSignInService appleSignInService;

  AuthService({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.appleSignInService,
  });

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  Future<User> signUp(SignUpDTO dto) async {
    try {
      final UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );
      return checkUserCredential(credential);
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

      return checkUserCredential(credential);
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
    try {
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
        return checkUserCredential(userCredential);
      }

      throw FirebaseAuthException(
        code: 'sign_in_failed',
        message: 'Sign in failed',
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  Future<User> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await appleSignInService.getAppleIDCredential(
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
      return checkUserCredential(userCredential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw "${e.message}";
      }
      rethrow;
    }
  }

  User checkUserCredential(UserCredential credential) {
    if (credential.user != null) {
      return credential.user!;
    } else {
      throw FirebaseAuthException(
          code: 'sign_in_failed', message: 'User not found');
    }
  }
}
