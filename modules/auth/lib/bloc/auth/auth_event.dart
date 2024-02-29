part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequest extends AuthEvent {
  final SignUpDTO dto;

  const SignUpRequest({required this.dto});

  @override
  List<Object> get props => [dto];
}

class SignUpByGoogleRequest extends AuthEvent {}

class SignInRequest extends AuthEvent {
  final SignInDTO signInDTO;

  const SignInRequest({required this.signInDTO});

  @override
  List<Object> get props => [signInDTO];
}

class ForgotPasswordRequest extends AuthEvent {
  final String email;

  const ForgotPasswordRequest({required this.email});

  @override
  List<Object> get props => [email];
}

class SignInByGoogleRequest extends AuthEvent {}
