import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:auth/data/remote/user_services.dart';
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
