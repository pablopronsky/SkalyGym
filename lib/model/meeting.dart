import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/model/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meeting.g.dart';

@JsonSerializable()
class Meeting {
  String id;
  DateTime startTime;
  DateTime endTime;
  String subject;
  @JsonKey(name: 'reservations')
  List<Reservation>? reservations;
  @JsonKey(name: 'usersId')
  List<String>? usersId;

  Meeting({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.reservations,
    this.usersId,
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
      reservations: map['reservations'] != null
          ? List<Reservation>.from(map['reservations'] as List)
          : null,
      usersId: map['usersId'] != null
          ? List<String>.from(map['usersId'] as List)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': dateTimeToTimeStamp(startTime),
      'endTime': dateTimeToTimeStamp(endTime),
      'subject': subject,
      'reservations': reservations?.map((reserva) => reserva.toMap()).toList(),
      'usersId': usersId,
    };
  }

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Meeting(
      id: data['id'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      subject: data['subject'],
      reservations: (data['reservations'] as List)
          .map((i) => Reservation.fromMap(i))
          .toList(),
      usersId: List<String>.from(data['usersId']),
    );
  }

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
