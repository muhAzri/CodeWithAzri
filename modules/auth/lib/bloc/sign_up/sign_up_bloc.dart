import 'package:auth/data/dto/auth/sign_up_dto.dart';
import 'package:auth/data/dto/user/user_initialization_dto.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:auth/data/remote/user_services.dart';
import 'package:cwa_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthService services;
  final UserService userService;

  SignUpBloc({
    required this.services,
    required this.userService,
  }) : super(SignUpInitial()) {
    on<SignUpRequest>(onSignUp);
    on<SignUpByGoogleRequest>(onSignUpByGoogle);
  }

  Future<void> onSignUp(SignUpRequest event, emit) async {
    try {
      emit(SignUpLoading());

      final user = await services.signUp(event.dto);
      await userService.initializeUser(UserInitializationDTO(
        id: user.uid,
        name: event.dto.name,
        email: event.dto.email,
        profilePicture: user.photoURL ?? getAvatarUrl(event.dto.name),
      ));

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailed(error: e.toString()));
    }
  }

  Future<void> onSignUpByGoogle(SignUpByGoogleRequest event, emit) async {
    try {
      emit(SignUpLoading());

      final user = await services.signInWithGoogle();
      await userService.initializeUser(UserInitializationDTO(
        id: user.uid,
        name: user.displayName!,
        email: user.email!,
        profilePicture: user.photoURL!,
      ));

      emit(SignUpSuccess());
    } catch (e) {
      emit(
        SignUpFailed(
          error: e.toString(),
        ),
      );
    }
  }
}
