import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_client.dart';

class AlumnoServicio {
  void registrarAlumno(String uid, String email, String nombre, String apellido, String numeroDeCelular) {
    Alumno alumno = Alumno(uid, nombre, apellido, email, numeroDeCelular, 3, DateTime.now());
    FirebaseFirestore.instance.collection('alumnos').add({
      'uid': alumno.uid,
      'nombre': alumno.nombre,
      'apellido': alumno.apellido,
      'email': alumno.email,
      'numeroDeCelular': alumno.numeroDeCelular,
      'packDeClases': alumno.packDeClases,
      'fechaDeNacimiento': alumno.fechaDeNacimiento,
    });
  }
}