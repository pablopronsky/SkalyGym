import 'package:json_annotation/json_annotation.dart';

import 'enum_rol.dart';
import 'user.dart';
part 'user_client.g.dart';

@JsonSerializable()
class Alumno extends Usuario {
  int weeklyCredits;
  Role role;

  Alumno(
    String name,
    String lastName,
    String email,
    String phoneNumber,
    this.weeklyCredits,
    this.role,
  ) : super(name, lastName, email, phoneNumber);

  factory Alumno.fromJson(Map<String, dynamic> json) => _$AlumnoFromJson(json);

  Map<String, dynamic> toJson() => _$AlumnoToJson(this);

  factory Alumno.fromMap(Map<String, dynamic> data) {
    return Alumno(
      data['name'] as String,
      data['lastName'] as String,
      data['email'] as String,
      data['phoneNumber'] as String,
      data['weeklyCredits'] as int,
      Role.values.byName(data['rol']),
    );
  }
}
