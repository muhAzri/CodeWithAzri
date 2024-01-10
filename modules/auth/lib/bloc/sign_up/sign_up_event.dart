part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequest extends SignUpEvent {
  final SignUpDTO dto;

  const SignUpRequest({required this.dto});

  @override
  List<Object> get props => [dto];
}

class SignUpByGoogleRequest extends SignUpEvent {}
