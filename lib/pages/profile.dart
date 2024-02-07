import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';

import '../model/user_client.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
      FirebaseFirestore.instance
          .collection('alumnos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  List<Alumno> alumnos = [];

  @override
  void initState() {
    super.initState();
    userStream.listen((querySnapshot) {
      alumnos = querySnapshot.docs.map((doc) {
        return Alumno.fromJson(
            doc.data()); // Use fromJson to create Alumno objects
      }).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: ListView.builder(
        itemCount: alumnos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${alumnos[index].nombre},${alumnos[index].apellido}'),
            subtitle: Text(alumnos[index].email),
            trailing: Text('${alumnos[index].packDeClases} clases'),
          );
        },
      ),
    );
  }
}
