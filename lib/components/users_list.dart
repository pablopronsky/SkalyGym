import 'package:flutter/material.dart';

import '../model/user_client.dart';
import '../services/client_service.dart';

class ListaAlumnos extends StatelessWidget {
  const ListaAlumnos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Alumno>>(
        future: AlumnoServicio().obtenerTodosLosAlumnos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final alumno = snapshot.data![index];
                return ListTile(
                  title: Text(
                      '${alumno.nombre.toUpperCase()} ${alumno.apellido.toUpperCase()}'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
