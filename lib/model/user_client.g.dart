// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alumno _$AlumnoFromJson(Map<String, dynamic> json) => Alumno(
      json['name'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['phoneNumber'] as String,
      json['weeklyCredits'] as int,
      $enumDecode(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$AlumnoToJson(Alumno instance) => <String, dynamic>{
      'name': instance.nombre,
      'lastName': instance.apellido,
      'email': instance.email,
      'phoneNumber': instance.numeroDeCelular,
      'weeklyCredits': instance.weeklyCredits,
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$RoleEnumMap = {
  Role.Admin: 'Admin',
  Role.User: 'User',
};
