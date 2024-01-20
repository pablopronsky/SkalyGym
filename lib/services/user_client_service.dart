import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/enum_rol.dart';
import '../model/user_client.dart';

class AlumnoServicio {
  void registrarAlumno(String uid, String email, String nombre, String apellido,
      String numeroDeCelular) {
    Alumno alumno = Alumno(uid, nombre, apellido, email, numeroDeCelular, 3,
        DateTime.now(), Rol.Alumno);
    FirebaseFirestore.instance.collection('alumnos').add({
      'uid': alumno.uid,
      'nombre': alumno.nombre,
      'apellido': alumno.apellido,
      'email': alumno.email,
      'numeroDeCelular': alumno.numeroDeCelular,
      'packDeClases': alumno.packDeClases,
      'fechaDeNacimiento': alumno.fechaDeNacimiento,
      'rol': alumno.rol.name,
    });
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
        doc['fechaDeNacimiento'].toDate(),
        Rol.values.byName(doc['rol']),
      );
      listaDeAlumnos.add(alumno);
    }
    return listaDeAlumnos;
  }

  void modificarAlumno(String uid, Alumno alumnoActualizado) {
    DocumentReference alumnoModificar =
    FirebaseFirestore.instance.collection('alumnos').doc(uid);

    // Actualizar los datos del documento
    alumnoModificar.update({
      'nombre': alumnoActualizado.nombre,
      'apellido': alumnoActualizado.apellido,
      'email': alumnoActualizado.email,
      'numeroDeCelular': alumnoActualizado.numeroDeCelular,
      'packDeClases': alumnoActualizado.packDeClases,
      'fechaDeNacimiento': alumnoActualizado.fechaDeNacimiento,
      'rol': alumnoActualizado.rol.name,
    });
  }

  void borrarAlumno(String uid) {
    DocumentReference alumnoBorrar =
    FirebaseFirestore.instance.collection('alumnos').doc(uid);
    alumnoBorrar.delete();
  }

  Future<List<Alumno>> buscarAlumnosPorApellido(String apellido) async {
    Query query = FirebaseFirestore.instance.collection('alumnos').where('apellido',
        isEqualTo: apellido);
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
        doc['fechaDeNacimiento'].toDate(),
        Rol.values.byName(doc['rol']),
      );
      listaDeAlumnos.add(alumno);
    }

    return listaDeAlumnos;
  }
}
