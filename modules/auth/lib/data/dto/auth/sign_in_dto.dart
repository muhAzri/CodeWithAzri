import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_dto.g.dart';

@JsonSerializable()
class SignInDTO extends Equatable {
  final String email;
  final String password;

  const SignInDTO({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];

  factory SignInDTO.fromJson(Map<String, dynamic> json) =>
      _$SignInDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SignInDTOToJson(this);
}
