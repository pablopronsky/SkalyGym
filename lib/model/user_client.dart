import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enum_rol.dart';
import 'user.dart';
part 'user_client.g.dart';

@JsonSerializable()
class UserClient extends Usuario {
  int weeklyCredits;
  Role role;

  UserClient(
    String name,
    String lastName,
    String email,
    String phoneNumber,
    this.weeklyCredits,
    this.role,
  ) : super(name, lastName, email, phoneNumber);

  factory UserClient.fromFirestore(DocumentSnapshot doc) =>
      UserClient.fromJson(doc.data() as Map<String, dynamic>);

  factory UserClient.fromJson(Map<String, dynamic> json) => _$UserClientFromJson(json);

  Map<String, dynamic> toJson() => _$UserClientToJson(this);
}
