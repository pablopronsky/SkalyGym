import 'package:gym/model/user.dart';

import 'enum_rol.dart';

class Admin extends Usuario {
  Rol rol;
  Admin(
    String uid,
    String nombre,
    String apellido,
    String email,
    String numeroDeCelular,
    this.rol,
  ) : super(uid, nombre, apellido, email, numeroDeCelular);
}
