import 'package:cloud_firestore/cloud_firestore.dart';
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

  int get freeSlotsCount {
    return maxMeetingCapacity - userId!.length;
  }

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
      userId: List<String>.from(data['userId'] ?? []),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "startTime": Timestamp.fromDate(startTime),
      "endTime": Timestamp.fromDate(endTime),
      "subject": subject,
      "maxMeetingCapacity": maxMeetingCapacity,
      "numParticipants": numParticipants,
      "userId": userId,
    };
  }
}