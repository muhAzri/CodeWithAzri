import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:networking/config/dio_interceptor.dart';

void setupSingletonDepedencies(GetIt getIt) {
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn(
    scopes: [
      "openid",
      'email',
      "profile",
    ],
  ));
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<DioInterceptor>(DioInterceptor());
}
