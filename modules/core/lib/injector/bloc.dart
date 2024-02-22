import 'package:auth/bloc/sign_in/sign_in_bloc.dart';
import 'package:auth/bloc/sign_up/sign_up_bloc.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:auth/data/remote/user_services.dart';
import 'package:get_it/get_it.dart';

void setUpBlocDepedencies(GetIt getIt) {
  ///Auth Blocs
  getIt.registerFactory<SignInBloc>(
    () => SignInBloc(
      services: getIt<AuthService>(),
      userService: getIt<UserService>(),
    ),
  );
  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(
      services: getIt<AuthService>(),
      userService: getIt<UserService>(),
    ),
  );
}
