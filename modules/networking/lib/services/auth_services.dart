import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final AuthServiceImpl service = AuthServiceImpl(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(
      scopes: [
        "openid",
        "email",
        "profile",
      ],
    ),
  );

  static AuthServiceImpl call() {
    return service;
  }
}

class AuthServiceImpl {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthServiceImpl({required this.firebaseAuth, required this.googleSignIn});

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
      throw FirebaseAuthException(
        code: 'sign_in_failed',
        message: 'Sign in with Google failed',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      final user = await _signInWithGoogleCredentials(
        googleAuth.accessToken!,
        googleAuth.idToken!,
      );
      return _checkUser(user);
    }

    throw FirebaseAuthException(
      code: 'sign_in_failed',
      message: 'Sign in failed',
    );
  }

  Future<User?> _signInWithGoogleCredentials(
      String accessToken, String idToken) async {
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<User> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ],
    );
    final user = await _signInWithAppleCredentials(appleCredential);
    return _checkUser(user);
  }

  Future<User?> _signInWithAppleCredentials(
      AuthorizationCredentialAppleID credential) async {
    final OAuthCredential oAuthCredential =
        OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
    );
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(oAuthCredential);
    return userCredential.user;
  }

  User _checkUserCredential(UserCredential credential) {
    if (credential.user != null) {
      return credential.user!;
    } else {
      throw FirebaseAuthException(
          code: 'sign_in_failed', message: 'User not found');
    }
  }

  User _checkUser(User? user) {
    if (user != null) {
      return user;
    } else {
      throw FirebaseAuthException(
          code: 'sign_in_failed', message: 'User not found');
    }
  }

  AuthServiceImpl call() {
    return this;
  }
}
