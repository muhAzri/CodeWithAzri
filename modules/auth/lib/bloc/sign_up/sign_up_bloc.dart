import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:models/dto/user/user_initialization_dto.dart';
import 'package:networking/services/auth_services.dart';
import 'package:networking/services/user_services.dart';

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
