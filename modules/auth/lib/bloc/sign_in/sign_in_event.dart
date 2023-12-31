part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequest extends SignInEvent {
  final SignInDTO signInDTO;

  const SignInRequest({required this.signInDTO});
}

class ForgotPasswordRequest extends SignInEvent {
  final String email;

  const ForgotPasswordRequest({required this.email});
}

class SignInByGoogleRequest extends SignInEvent {}
