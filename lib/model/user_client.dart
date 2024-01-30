import 'package:json_annotation/json_annotation.dart';

import 'enum_rol.dart';
import 'user.dart';
part 'user_client.g.dart';

@JsonSerializable()
class Alumno extends Usuario {
  int packDeClases;
  DateTime fechaDeNacimiento;
  Rol rol;

  Alumno(
    String uid,
    String nombre,
    String apellido,
    String email,
    String numeroDeCelular,
    this.packDeClases,
    this.fechaDeNacimiento,
    this.rol,
  ) : super(uid, nombre, apellido, email, numeroDeCelular);

  @override
  String toString() {
    return 'Alumno{packDeClases: $packDeClases, fechaDeNacimiento: $fechaDeNacimiento, rol: $rol}';
  }
}
