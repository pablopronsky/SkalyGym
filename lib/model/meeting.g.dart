// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
      eventName: json['eventName'] as String,
      from: DateTime.parse(json['from'] as String),
      to: DateTime.parse(json['to'] as String),
      reservas: (json['reservas'] as List<dynamic>?)
          ?.map((e) => Reserva.fromJson(e as Map<String, dynamic>))
          .toList(),
      idAlumno: (json['idAlumno'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      claseLlena: json['claseLlena'] as bool? ?? false,
      recurrenceRule: json['recurrenceRule'] as String?,
    );

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'eventName': instance.eventName,
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'reservas': instance.reservas,
      'idAlumno': instance.idAlumno,
      'claseLlena': instance.claseLlena,
      'recurrenceRule': instance.recurrenceRule,
    };
