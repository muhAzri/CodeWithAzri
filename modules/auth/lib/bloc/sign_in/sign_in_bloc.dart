import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/DTO/auth/sign_in_dto.dart';
import 'package:networking/services/auth_services.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService services;

  SignInBloc({AuthService? service})
      : services = service ?? AuthService(),
        super(SignInInitial()) {
    on<SignInRequest>(onSignIn);
    on<ForgotPasswordRequest>(onForgotPassword);
    on<SignInByGoogleRequest>(onSignInByGoogle);
  }

  Future<void> onSignIn(SignInRequest event, emit) async {
    try {
      emit(SignInLoading());

      await services.signInWithEmailAndPassword(event.signInDTO);

      emit(SignInSuccess());
    } catch (e) {
      emit(
        SignInFailed(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> onForgotPassword(ForgotPasswordRequest event, emit) async {
    try {
      emit(ForgotPasswordLoading());

      await services.sendPasswordResetEmail(event.email);

      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(
        ForgotPasswordFailed(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> onSignInByGoogle(SignInByGoogleRequest event, emit) async {
    try {
      emit(SignInLoading());

      await services.signInWithGoogle();

      emit(SignInSuccess());
    } catch (e) {
      emit(
        SignInFailed(
          error: e.toString(),
        ),
      );
    }
  }
}
