// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alumno _$AlumnoFromJson(Map<String, dynamic> json) => Alumno(
      json['uid'] as String,
      json['nombre'] as String,
      json['apellido'] as String,
      json['email'] as String,
      json['numeroDeCelular'] as String,
      json['packDeClases'] as int,
      DateTime.parse(json['fechaDeNacimiento'] as String),
      $enumDecode(_$RolEnumMap, json['rol']),
    );

Map<String, dynamic> _$AlumnoToJson(Alumno instance) => <String, dynamic>{
      'uid': instance.uid,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'email': instance.email,
      'numeroDeCelular': instance.numeroDeCelular,
      'packDeClases': instance.packDeClases,
      'fechaDeNacimiento': instance.fechaDeNacimiento.toIso8601String(),
      'rol': _$RolEnumMap[instance.rol]!,
    };

const _$RolEnumMap = {
  Rol.Admin: 'Admin',
  Rol.Alumno: 'Alumno',
};
