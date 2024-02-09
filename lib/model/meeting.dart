import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/model/appointment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting.g.dart';

@JsonSerializable()
class Meeting {
  String id;
  DateTime startTime;
  DateTime endTime;
  String subject;
  @JsonKey(name: 'reservas')
  List<Reserva>? reservas;
  @JsonKey(name: 'idAlumno')
  List<String>? idAlumno;
  String? recurrenceRule;

  Meeting({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.reservas,
    this.idAlumno,
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
      id: map['id'] as String,
      startTime: timeStampToDateTime(map['startTime'] as Timestamp),
      endTime: timeStampToDateTime(map['endTime'] as Timestamp),
      subject: map['subject'] as String,
      reservas: map['reservas'] != null
          ? List<Reserva>.from(map['reservas'] as List)
          : null,
      idAlumno: map['idAlumno'] != null
          ? List<String>.from(map['idAlumno'] as List)
          : null,
      recurrenceRule: map['recurrenceRule'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': dateTimeToTimeStamp(startTime),
      'endTime': dateTimeToTimeStamp(endTime),
      'subject': subject,
      'reservas': reservas?.map((reserva) => reserva.toMap()).toList(),
      'idAlumno': idAlumno,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Meeting(
      id: data['id'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      subject: data['subject'],
      reservas:
          (data['reservas'] as List).map((i) => Reserva.fromMap(i)).toList(),
      idAlumno: List<String>.from(data['idAlumno']),
    );
  }

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
