// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_initialization_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInitializationDTO _$UserInitializationDTOFromJson(
        Map<String, dynamic> json) =>
    UserInitializationDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserInitializationDTOToJson(
        UserInitializationDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
