// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reserva _$ReservaFromJson(Map<String, dynamic> json) => Reserva(
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
      json['idAlumno'] as String,
      json['idClase'] as String,
    );

Map<String, dynamic> _$ReservaToJson(Reserva instance) => <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'idAlumno': instance.idAlumno,
      'idClase': instance.idClase,
    };
