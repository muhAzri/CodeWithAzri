import 'package:auth/data/dto/auth/sign_in_dto.dart';
import 'package:auth/data/dto/user/user_initialization_dto.dart';
import 'package:auth/data/remote/auth_services.dart';
import 'package:auth/data/remote/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService services;
  final UserService userService;

  SignInBloc({
    required this.services,
    required this.userService,
  }) : super(SignInInitial()) {
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

      final user = await services.signInWithGoogle();
      await userService.initializeUser(UserInitializationDTO(
        id: user.uid,
        name: user.displayName!,
        email: user.email!,
        profilePicture: user.photoURL!,
      ));

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
