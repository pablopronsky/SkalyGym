import 'user.dart';

class Alumno extends Usuario {
  int packDeClases;
  DateTime fechaDeNacimiento;

  Alumno(
      String uid,
      String nombre,
      String apellido,
      String email,
      String numeroDeCelular,
      this.packDeClases,
      this.fechaDeNacimiento,
      ) : super(uid, nombre, apellido, email, numeroDeCelular);
}