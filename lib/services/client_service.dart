import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/enum_rol.dart';
import '../model/user_client.dart';

class AlumnoServicio {
  final Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
      FirebaseFirestore.instance
          .collection('alumnos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  String nombre = '';
  String apellido = '';
  int packDeClases = 0;

  void registrarAlumno(String uid, String email, String nombre, String apellido,
      String numeroDeCelular) {
    final alumno =
        Alumno(uid, nombre, apellido, email, numeroDeCelular, 3, Rol.Alumno);
    final documentId = '${alumno.nombre} ${alumno.apellido}';
    final json = alumno.toJson();

    final documentRef =
        FirebaseFirestore.instance.collection('alumnos').doc(documentId);

    documentRef.set(json);
  }

  void modificarAlumno(String uid, Alumno alumnoActualizado) {
    DocumentReference alumnoModificar =
        FirebaseFirestore.instance.collection('alumnos').doc(uid);

    alumnoModificar.update({
      'uid': alumnoActualizado.uid,
      'nombre': alumnoActualizado.nombre,
      'apellido': alumnoActualizado.apellido,
      'email': alumnoActualizado.email,
      'numeroDeCelular': alumnoActualizado.numeroDeCelular,
      'packDeClases': alumnoActualizado.packDeClases,
      'rol': alumnoActualizado.rol.name,
    });
  }
}
