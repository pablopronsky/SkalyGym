import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import '../model/appointment_data_source.dart';
import '../model/user_client.dart';
import '../services/user_client_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CalendarController _calendarController;
  DateTime today = DateTime.now();
  DateTime mostRecentSunday(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday % 1);

  DateTime mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - date.weekday % 2);

  DateTime mostRecentSaturday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 7));

  DateTime firstSaturdayFromToday(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

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
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: 10)),
      subject: 'Meeting',
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return AppointmentDataSource(appointments);
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
          const SizedBox(
            height: 60,
          ),
          SfCalendar(
            view: CalendarView.week,
            firstDayOfWeek: 1,
            controller: _calendarController,
            dataSource: _getCalendarDataSource(),
            appointmentTextStyle: const TextStyle(
                fontSize: 25,
                color: Color(0xFFd89cf6),
                letterSpacing: 5,
                fontWeight: FontWeight.bold
            ),
            appointmentTimeTextFormat: 'HH:mm',
          ),
          const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Alumno>>(
              future: AlumnoServicio().obtenerTodosLosAlumnos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    // Use ListView.builder for efficient scrolling
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final alumno = snapshot.data![index];
                      return ListTile(
                        title: Text(
                            '${alumno.nombre.toUpperCase()} ${alumno.apellido.toUpperCase()}'),
                        // Consider adding trailing for additional actions
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