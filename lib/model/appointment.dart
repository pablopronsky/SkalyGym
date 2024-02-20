import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Reserva {
  DateTime startTime;
  DateTime endTime;
  String idAlumno;
  String idClase;

  Reserva(this.startTime, this.endTime, this.idAlumno, this.idClase);

  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': Timestamp.fromDate(startTime), // Store as Timestamp
      'endTime': Timestamp.fromDate(endTime), // Store as Timestamp
      'idAlumno': idAlumno,
      'idClase': idClase,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      (map['startTime'] as Timestamp)
          .toDate(), // Retrieve startTime as Timestamp
      (map['endTime'] as Timestamp).toDate(), // Retrieve endTime as Timestamp
      map['idAlumno'],
      map['idClase'],
    );
  }
  Map<String, dynamic> toJson() => _$ReservaToJson(this);

  factory Reserva.fromJson(Map<String, dynamic> json) =>
      _$ReservaFromJson(json);
}
