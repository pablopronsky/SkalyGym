// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) => Meeting(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      subject: json['subject'] as String,
      reservas: (json['reservas'] as List<dynamic>?)
          ?.map((e) => Reserva.fromJson(e as Map<String, dynamic>))
          .toList(),
      idAlumno: (json['idAlumno'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recurrenceRule: json['recurrenceRule'] as String?,
    );

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'subject': instance.subject,
      'reservas': instance.reservas,
      'idAlumno': instance.idAlumno,
      'recurrenceRule': instance.recurrenceRule,
    };
