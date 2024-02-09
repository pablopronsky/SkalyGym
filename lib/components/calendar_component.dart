import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/appointment.dart';
import '../model/firestore_data_source.dart';
import '../model/meeting.dart';
import '../model/user_client.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  Future<bool> _isClassFull(Meeting meeting) async {
    const maxCapacity = 6;
    // Retrieve 'reservas' count from Firestore (if not directly in the Meeting object)
    if (meeting.reservas == null) {
      final reservasCount = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(meeting.id) // Use the Meeting object's document ID
          .collection('reservas')
          .get()
          .then((snapshot) => snapshot.size);

      return reservasCount >= maxCapacity;
    } else {
      return meeting.reservas!.length >= maxCapacity;
    }
  }

  Future<void> _makeAppointment(Meeting meeting, Reserva reserva) async {
    final currentStudentEmail = FirebaseAuth.instance.currentUser!.email; // Assumes email exists

    // Fetch corresponding Alumno data using email as document ID
    final alumnoDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentStudentEmail)
        .get();
    final Alumno alumno = Alumno.fromMap(alumnoDoc.data()!);

    List<String> reservedClassIds = alumno.clasesReservadas;

    final meetingRef =
        FirebaseFirestore.instance.collection('clases').doc(meeting.id);

    // Transaction for consistency (Optional, but safer)
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final currentMeetingData =
          (await transaction.get(meetingRef)).data() as Map<String, dynamic>;
      // ... (Check claseLlena using currentMeetingData if needed) ...

      transaction.update(meetingRef, {
        'reservas': FieldValue.arrayUnion([reserva.toMap()]),
        'idAlumno': FieldValue.arrayUnion([currentStudentEmail]),
        // ... Add field to track class fullness  and update based on currentMeetingData, if needed
      });

      transaction.update(alumnoDoc.reference, {
        'clasesReservadas': FieldValue.arrayUnion(
            [meeting.id]) // Track reservations in Alumno document
      });
    });
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      final Meeting tappedMeeting = calendarTapDetails.appointments!.first;
      _showAppointmentDialog(context, tappedMeeting);
    }
  }

  void _showAppointmentDialog(BuildContext context, Meeting meeting) async {
    // Build Reserva object
    Reserva newReserva = Reserva(
      meeting.startTime,
      meeting.endTime,
      FirebaseAuth.instance.currentUser!.uid,
      meeting.id,
    );

    // Call _isClassFull here and store the result
    bool isClassFull = await _isClassFull(meeting);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[300], // Background color
        contentTextStyle: const TextStyle(color: Colors.black),
        title: Text(
            'Reservar clase: ${DateFormat('HH:mm').format(meeting.startTime)}'),
        content: isClassFull
            ? const Text('La clase esta llena')
            : Text(
                '¿Confirmar reserva? ${DateFormat('HH:mm').format(meeting.startTime)} - ${DateFormat('HH:mm').format(meeting.endTime)}'),
        actions: <Widget>[
          TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
              }),
          if (!isClassFull)
            TextButton(
              child:
                  const Text('Reservar', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                _makeAppointment(meeting, newReserva);
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }

  final double _height = 0.0;
  var myTimezone = 'America/Buenos_Aires';

  Future<int> getStudentCount(String claseId) async {
    final studentCount = await FirebaseFirestore.instance
        .collection('clases')
        .doc(claseId)
        .collection('reservas')
        .get()
        .then((snapshot) => snapshot.size);
    return studentCount;
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      backgroundColor: Colors.grey[300],
      view: CalendarView.schedule,
      dataSource: FirestoreStreamDataSource(),
      onTap: calendarTapped,
      timeZone: 'Argentina Standard Time',
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: Colors.white30,
        textAlign: TextAlign.center,
        textStyle: TextStyle(color: Colors.white),
      ),
      monthViewSettings:
          MonthViewSettings(showAgenda: true, agendaViewHeight: _height),
      appointmentTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      scheduleViewSettings: const ScheduleViewSettings(
        appointmentItemHeight: 50,

        // SECTOR MENSUAL
        monthHeaderSettings: MonthHeaderSettings(
            monthFormat: 'MMMM, yyyy',
            height: 80,
            textAlign: TextAlign.center,
            backgroundColor: Colors.white24,
            monthTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400)),

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
              color: Colors.black,
            ),
            dateTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            )),
      ),
    );
  }
}
