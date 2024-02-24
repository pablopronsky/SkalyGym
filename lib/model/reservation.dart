import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  DateTime startTime;
  DateTime endTime;
  String userId;
  String meetingId;

  Reservation(this.startTime, this.endTime, this.userId, this.meetingId);

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
      'userId': userId,
      'meetingId': meetingId,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      (map['startTime'] as Timestamp)
          .toDate(), // Retrieve startTime as Timestamp
      (map['endTime'] as Timestamp).toDate(), // Retrieve endTime as Timestamp
      map['userId'],
      map['meetingId'],
    );
  }
  Map<String, dynamic> toJson() => _$ReservaToJson(this);

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservaFromJson(json);
}
