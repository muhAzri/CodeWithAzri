// coverage:ignore-file

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AppleSignInService {
  Future<AuthorizationCredentialAppleID> getAppleIDCredential(
      {required List<AppleIDAuthorizationScopes> scopes});
}

class AppleSignInServiceImpl implements AppleSignInService {
  @override
  Future<AuthorizationCredentialAppleID> getAppleIDCredential(
      {required List<AppleIDAuthorizationScopes> scopes}) async {
    return await SignInWithApple.getAppleIDCredential(scopes: scopes);
  }
}
