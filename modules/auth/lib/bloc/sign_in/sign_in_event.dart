part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInRequest extends SignInEvent {
  final SignInDTO signInDTO;

  const SignInRequest({required this.signInDTO});

  @override
  List<Object> get props => [signInDTO];
}

class ForgotPasswordRequest extends SignInEvent {
  final String email;

  const ForgotPasswordRequest({required this.email});

  @override
  List<Object> get props => [email];
}

class SignInByGoogleRequest extends SignInEvent {}
