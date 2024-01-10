import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:networking/config/dio_interceptor.dart';
import 'package:networking/services/apple_sign_in_service.dart';
import 'package:networking/services/auth_services.dart';
import 'package:networking/services/user_services.dart';

void setUpServicesDepedencies(GetIt getIt) {
  getIt.registerFactory<AuthService>(
    () => AuthService(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<GoogleSignIn>(),
      appleSignInService: getIt<AppleSignInService>(),
    ),
  );

  getIt.registerFactory<UserService>(
    () => UserService(
      client: getIt<DioInterceptor>(),
    ),
  );
}
