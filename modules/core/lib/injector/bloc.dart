
import 'package:auth/auth.dart';
import 'package:get_it/get_it.dart';

void setUpBlocDepedencies(GetIt getIt) {
  ///Auth Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      services: getIt<AuthService>(),
      userService: getIt<UserService>(),
    ),
  );
}
