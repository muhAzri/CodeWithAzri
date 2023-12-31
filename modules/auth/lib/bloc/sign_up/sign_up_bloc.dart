import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/DTO/auth/sign_up_dto.dart';
import 'package:networking/services/auth_services.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthServiceImpl services;

  SignUpBloc({AuthServiceImpl? service})
      : services = service ?? AuthService.call(),
        super(SignUpInitial()) {
    on<SignUpRequest>(onSignUp);
    on<SignUpByGoogleRequest>(onSignUpByGoogle);
  }

  Future<void> onSignUp(SignUpRequest event, emit) async {
    try {
      emit(SignUpLoading());

      await services.signUp(event.dto);

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailed(error: e.toString()));
    }
  }

  Future<void> onSignUpByGoogle(SignUpByGoogleRequest event, emit) async {
    try {
      emit(SignUpLoading());

      await services.signInWithGoogle();

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
