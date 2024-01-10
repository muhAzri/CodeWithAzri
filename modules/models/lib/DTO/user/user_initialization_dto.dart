import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_initialization_dto.g.dart';

@JsonSerializable()
class UserInitializationDTO extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserInitializationDTO({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, email];

  factory UserInitializationDTO.fromJson(Map<String, dynamic> json) =>
      _$UserInitializationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserInitializationDTOToJson(this);
}
