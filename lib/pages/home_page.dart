// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../components/calendar.dart';
import '../model/user_client.dart';
import '../services/client_service.dart';

class HomePage extends StatefulWidget  {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuario = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            // centrar texto verticalmente y tartar que muestre nombre+apellido
            child: Text(
              usuario.email!,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Calendar(),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
