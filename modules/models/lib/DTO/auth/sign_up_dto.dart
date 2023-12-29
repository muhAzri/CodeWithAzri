import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_dto.g.dart';

@JsonSerializable()
class SignUpDTO extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignUpDTO({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];

  factory SignUpDTO.fromJson(Map<String, dynamic> json) =>
      _$SignUpDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpDTOToJson(this);
}
