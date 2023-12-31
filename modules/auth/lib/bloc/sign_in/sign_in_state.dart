part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInFailed extends SignInState {
  final String error;

  const SignInFailed({required this.error});
}

final class SignInSuccess extends SignInState {}

final class ForgotPasswordLoading extends SignInState {}

final class ForgotPasswordFailed extends SignInState {
  final String error;

  const ForgotPasswordFailed({required this.error});
}

final class ForgotPasswordSuccess extends SignInState {}
