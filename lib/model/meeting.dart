import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/model/class_reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting.g.dart';

@JsonSerializable()
class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  @JsonKey(name: 'reservas')
  List<Reserva>? reservas;
  @JsonKey(name: 'idAlumno')
  List<String>? idAlumno;
  bool claseLlena;
  String? recurrenceRule;

  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    this.reservas,
    this.idAlumno,
    this.claseLlena = false,
    this.recurrenceRule,
  });

  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now());
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      eventName: map['eventName'] as String,
      from: timeStampToDateTime(map['from'] as Timestamp),
      to: timeStampToDateTime(map['to'] as Timestamp),
      reservas: map['reservas'] != null
          ? List<Reserva>.from(map['reservas'] as List)
          : null,
      idAlumno: map['idAlumno'] != null
          ? List<String>.from(map['idAlumno'] as List)
          : null,
      claseLlena: map['claseLlena'] as bool,
      recurrenceRule: map['recurrenceRule'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': dateTimeToTimeStamp(from),
      'to': dateTimeToTimeStamp(to),
      'reservas': reservas?.map((reserva) => reserva.toMap()).toList(),
      'idAlumno': idAlumno,
      'claseLlena': claseLlena,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
