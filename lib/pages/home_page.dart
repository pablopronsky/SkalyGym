import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/user_client.dart';
import '../services/user_client_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime today = DateTime.now();

  DateTime mostRecentSunday(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday % 7);

  DateTime mostRecentSaturday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 6));

  final usuario = FirebaseAuth.instance.currentUser!;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // cerrar sesion
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        )
      ]),

      body: Column(
        children: [
          Center(
            child: Text(
              usuario.email!,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 60,
          ),
          TableCalendar(
            locale: 'es_EN',
            rowHeight: 85,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            // Ajusta el primer día al domingo actual o anterior:
            firstDay: mostRecentSunday(DateTime.now()),
            // Ajusta el último día al próximo sábado:
            lastDay: mostRecentSaturday(DateTime.now()),
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.week,
          ),
            const SizedBox(height: 30),
            Expanded(
                child: FutureBuilder<List<Alumno>>(
                  future: AlumnoServicio().obtenerTodosLosAlumnos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Alumno alumno = snapshot.data![index];
                            return ListTile(
                              title: Text('${alumno.nombre} ${alumno.apellido}'),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator(
                      ));
                    }
                  },
                ),
              ),
        ],
      ),
    );
  }
}
