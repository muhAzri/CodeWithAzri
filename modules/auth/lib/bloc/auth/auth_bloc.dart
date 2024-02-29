import 'package:auth/auth.dart';
import 'package:cwa_core/core.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService services;
  final UserService userService;
  AuthBloc({
    required this.services,
    required this.userService,
  }) : super(AuthInitial()) {
    //  Sign Up Events
    on<SignUpRequest>(onSignUp);
    on<SignUpByGoogleRequest>(onSignUpByGoogle);
    //  Sign In Events
    on<SignInRequest>(onSignIn);
    on<ForgotPasswordRequest>(onForgotPassword);
    on<SignInByGoogleRequest>(onSignInByGoogle);
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
