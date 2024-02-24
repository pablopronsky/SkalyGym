// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservaFromJson(Map<String, dynamic> json) => Reservation(
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
      json['userId'] as String,
      json['meetingId'] as String,
    );

Map<String, dynamic> _$ReservaToJson(Reservation instance) => <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'userId': instance.userId,
      'meetingId': instance.meetingId,
    };
