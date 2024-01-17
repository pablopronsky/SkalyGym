import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  final usuario = FirebaseAuth.instance.currentUser!;

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
          TableCalendar(
            locale: 'es_EN',
            rowHeight: 80,
            headerStyle: const HeaderStyle(
                formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: today,
            lastDay: DateTime.now().add(const Duration(days: 7)),
            // calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
          ),
        ],
      ),
    );
  }
}
