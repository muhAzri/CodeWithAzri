part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpFailed extends SignUpState {
  final String error;

  const SignUpFailed({required this.error});

  // @override
  // List<Object> get props => [error];
}

final class SignUpSuccess extends SignUpState {}
