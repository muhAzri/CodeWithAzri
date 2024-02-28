part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

//  Sign Up States
final class SignUpLoading extends AuthState {}

final class SignUpFailed extends AuthState {
  final String error;

  const SignUpFailed({required this.error});

  @override
  List<Object> get props => [error];
}

//  Sign In States
final class SignUpSuccess extends AuthState {}

final class SignInLoading extends AuthState {}

final class SignInFailed extends AuthState {
  final String error;

  const SignInFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class SignInSuccess extends AuthState {}

final class ForgotPasswordLoading extends AuthState {}

final class ForgotPasswordFailed extends AuthState {
  final String error;

  const ForgotPasswordFailed({required this.error});

  @override
  List<Object> get props => [error];
}

final class ForgotPasswordSuccess extends AuthState {}
