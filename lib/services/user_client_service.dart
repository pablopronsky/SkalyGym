import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/enum_rol.dart';
import '../model/user_client.dart';

class AlumnoServicio {
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

  Future<List<Alumno>> obtenerTodosLosAlumnos() async {
    List<Alumno> listaDeAlumnos = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('alumnos').get();
    for (var doc in querySnapshot.docs) {
      Alumno alumno = Alumno(
        doc['uid'],
        doc['nombre'],
        doc['apellido'],
        doc['email'],
        doc['numeroDeCelular'],
        doc['packDeClases'],
        Rol.values.byName(doc['rol']),
      );
      listaDeAlumnos.add(alumno);
    }
    return listaDeAlumnos;
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

  void borrarAlumno(String uid) {
    DocumentReference alumnoBorrar =
        FirebaseFirestore.instance.collection('alumnos').doc(uid);
    alumnoBorrar.delete();
  }

  Future<List<Alumno>> buscarAlumnosPorApellido(String apellido) async {
    Query query = FirebaseFirestore.instance
        .collection('alumnos')
        .where('apellido', isEqualTo: apellido);
    QuerySnapshot querySnapshot = await query.get();
    List<Alumno> listaDeAlumnos = [];
    for (var doc in querySnapshot.docs) {
      Alumno alumno = Alumno(
        doc['uid'],
        doc['nombre'],
        doc['apellido'],
        doc['email'],
        doc['numeroDeCelular'],
        doc['packDeClases'],
        Rol.values.byName(doc['rol']),
      );
      listaDeAlumnos.add(alumno);
    }

    return listaDeAlumnos;
  }
}
