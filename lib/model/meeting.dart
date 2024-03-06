import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/model/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Meeting {
  String id;
  DateTime startTime;
  DateTime endTime;
  String subject;
  @JsonKey(name: 'userId')
  List<String>? userId;
  int maxMeetingCapacity;
  int? numParticipants;

  Meeting({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.maxMeetingCapacity,
    this.userId,
    required this.numParticipants,
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
      maxMeetingCapacity: data['maxMeetingCapacity'],
      numParticipants: data['numParticipants'],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(startTime),
      "title": subject,
      "description": userId,
    };
  }
}