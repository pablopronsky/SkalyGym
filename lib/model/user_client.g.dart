// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alumno _$AlumnoFromJson(Map<String, dynamic> json) => Alumno(
      json['nombre'] as String,
      json['apellido'] as String,
      json['email'] as String,
      json['numeroDeCelular'] as String,
      (json['clasesReservadas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['packDeClases'] as int,
      $enumDecode(_$RolEnumMap, json['rol']),
    );

Map<String, dynamic> _$AlumnoToJson(Alumno instance) => <String, dynamic>{
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'email': instance.email,
      'numeroDeCelular': instance.numeroDeCelular,
      'clasesReservadas': instance.clasesReservadas,
      'packDeClases': instance.packDeClases,
      'rol': _$RolEnumMap[instance.rol]!,
    };

const _$RolEnumMap = {
  Rol.Admin: 'Admin',
  Rol.Alumno: 'Alumno',
};
