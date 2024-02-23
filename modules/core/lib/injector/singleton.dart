import 'package:auth/auth.dart';
import 'package:cwa_core/config/dio_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

void setupSingletonDepedencies(GetIt getIt) {
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn(
    scopes: [
      "openid",
      'email',
      "profile",
    ],
  ));
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<AppleSignInService>(AppleSignInServiceImpl());
  getIt.registerSingleton<DioInterceptor>(DioInterceptor());
}
