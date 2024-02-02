import 'package:json_annotation/json_annotation.dart';

import 'enum_rol.dart';
import 'user.dart';
part 'user_client.g.dart';

@JsonSerializable()
class Alumno extends Usuario {
  int packDeClases;
  Rol rol;

  Alumno(
    String uid,
    String nombre,
    String apellido,
    String email,
    String numeroDeCelular,
    this.packDeClases,
    this.rol,
  ) : super(uid, nombre, apellido, email, numeroDeCelular);

  factory Alumno.fromJson(Map<String, dynamic> json) => _$AlumnoFromJson(json);

  Map<String, dynamic> toJson() => _$AlumnoToJson(this);
}
