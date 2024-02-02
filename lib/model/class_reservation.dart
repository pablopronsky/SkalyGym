import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_reservation.g.dart';

@JsonSerializable()
class Reserva {
  DateTime startTime;
  DateTime endTime;
  String idAlumno;
  String idClase;

  Reserva(this.startTime, this.endTime, this.idAlumno, this.idClase);

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      DateTime.parse(map['startTime']),
      DateTime.parse(map['endTime']),
      map['idAlumno'],
      map['idClase'],
    );
  }

  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'idAlumno': idAlumno,
      'idClase': idClase,
    };
  }

  Map<String, dynamic> toJson() => _$ReservaToJson(this);
  factory Reserva.fromJson(Map<String, dynamic> json) =>
      _$ReservaFromJson(json);
}
