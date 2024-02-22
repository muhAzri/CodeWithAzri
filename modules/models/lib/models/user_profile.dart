import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String profilePicture;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  @override
  List<Object> get props => [id, name, profilePicture];

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
