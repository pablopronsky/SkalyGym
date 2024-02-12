import 'package:json_annotation/json_annotation.dart';

import 'enum_rol.dart';
import 'user.dart';
part 'user_client.g.dart';

@JsonSerializable()
class Alumno extends Usuario {
  List<String> clasesReservadas = [];
  int packDeClases;
  Rol rol;

  Alumno(
    String nombre,
    String apellido,
    String email,
    String numeroDeCelular,
    List<String> clasesReservadas,
    this.packDeClases,
    this.rol,
  ) : super(nombre, apellido, email, numeroDeCelular);

  factory Alumno.fromJson(Map<String, dynamic> json) => _$AlumnoFromJson(json);

  Map<String, dynamic> toJson() => _$AlumnoToJson(this);

  factory Alumno.fromMap(Map<String, dynamic> data) {
    return Alumno(
      data['nombre'] as String,
      data['apellido'] as String,
      data['email'] as String,
      data['numeroDeCelular'] as String,
      List<String>.from(data['clasesReservadas'] ?? []),
      data['packDeClases'] as int,
      Rol.values.byName(data['rol']),
    );
  }
}
