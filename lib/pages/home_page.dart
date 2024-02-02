// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/firestore_data_source.dart';
import '../model/user_client.dart';
import '../services/client_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // vars
  DateTime today = DateTime.now();
  final usuario = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // cambiar color
      appBar: AppBar(actions: [
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        ),
      ]
      ),
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
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SfCalendar(
            view: CalendarView.schedule,
            dataSource: FirestoreStreamDataSource(),
            headerStyle: const CalendarHeaderStyle(
              backgroundColor: Colors.white30,
              textAlign: TextAlign.center,
            ),
            timeZone: 'Argentina Standard Time',
            appointmentTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
              scheduleViewSettings: const ScheduleViewSettings(

                // SECTOR MENSUAL
                monthHeaderSettings: MonthHeaderSettings(
                    monthFormat: 'MMMM',
                    height: 80,
                    textAlign: TextAlign.center,
                    backgroundColor: Colors.grey,
                    monthTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)
                ),

                  // SECTOR SEMANAL
                  weekHeaderSettings: WeekHeaderSettings(
                      startDateFormat: 'dd MMM ',
                      endDateFormat: 'dd MMM, yy',
                      height: 50,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.grey,
                      weekTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      )),

                  // SECTOR DIARIO
                  dayHeaderSettings: DayHeaderSettings(
                      dayFormat: 'EEEE',
                      width: 70,
                      dayTextStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      dateTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      )),
              ),
          ),
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
