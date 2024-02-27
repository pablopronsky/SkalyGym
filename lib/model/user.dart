import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g..dart';

@JsonSerializable()
class UserClient {
  String name;
  String lastName;
  String email;
  String phoneNumber;
  int weeklyCredits;

  UserClient(this.name, this.lastName, this.email, this.phoneNumber,
      this.weeklyCredits);

  factory UserClient.fromFirestore(DocumentSnapshot doc) =>
      UserClient.fromJson(doc.data() as Map<String, dynamic>);

  factory UserClient.fromJson(Map<String, dynamic> json) =>
      _$UserClientFromJson(json);

  Map<String, dynamic> toJson() => _$UserClientToJson(this);
}
