import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/enum_rol.dart';
import '../model/user_client.dart';

class AlumnoServicio {
  void registrarAlumno(String uid, String email, String nombre, String apellido, String numeroDeCelular) {
    Alumno alumno = Alumno(uid, nombre, apellido, email, numeroDeCelular,3, DateTime.now(), Rol.Alumno);
    FirebaseFirestore.instance.collection('alumnos').add({
      'uid': alumno.uid,
      'nombre': alumno.nombre,
      'apellido': alumno.apellido,
      'email': alumno.email,
      'numeroDeCelular': alumno.numeroDeCelular,
      'packDeClases': alumno.packDeClases,
      'fechaDeNacimiento': alumno.fechaDeNacimiento,
      'rol' : alumno.rol.name,
    });
  }

  Future<List<Alumno>> obtenerTodosLosAlumnos() async {
    List<Alumno> listaDeAlumnos = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('alumnos').get();
    for (var doc in querySnapshot.docs) {
      Alumno alumno = Alumno(
        doc['uid'],
        doc['nombre'],
        doc['apellido'],
        doc['email'],
        doc['numeroDeCelular'],
        doc['packDeClases'],
        doc['fechaDeNacimiento'].toDate(),
        doc['rol'],
      );
      listaDeAlumnos.add(alumno);
    }
    return listaDeAlumnos;
  }
}