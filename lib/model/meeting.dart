import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/model/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

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

  factory Meeting.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Meeting(
      startTime: data['startTime'].toDate(),
      endTime: data['endTime'].toDate(),
      subject: data['subject'],
      reservations: data['usersId'],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(startTime),
      "title": subject,
      "description": usersId,
    };
  }
}
