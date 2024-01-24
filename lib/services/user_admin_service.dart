import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/enum_rol.dart';
import '../model/user_admin.dart';

class AdminServicio {
  // lo registro manualmente por el momento, necesito tener un admin para poder crear clases.
  Admin registrarAdmin() {
    Admin admin = Admin("L13ng5pKGzaK4yUrpeITqoWPmCL2", "Hernan", "Flor",
        "admin@skaly.com", "2216429575", Rol.Admin);
    FirebaseFirestore.instance.collection('admin').add({
      'uid': admin.uid,
      'nombre': admin.nombre,
      'apellido': admin.apellido,
      'email': admin.email,
      'numeroDeCelular': admin.numeroDeCelular,
      'rol': admin.rol.name,
    });
    return admin;
  }
}
