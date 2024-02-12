import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/appointment.dart';
import '../model/firestore_data_source.dart';
import '../model/meeting.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  /// Determina si la clase está llena o no, devuelve bool
  Future<bool> _isClassFull(Meeting meeting) async {
    const maxCapacity = 6;

    final reservasCount = await FirebaseFirestore.instance
        .collection('clases')
        .doc(meeting.id)
        .collection('reservas')
        .get()
        .then((snapshot) => snapshot.size);

    return reservasCount >= maxCapacity;
  }

  /// Handles the appointment booking process, including class capacity checks and student data updates
  Future<void> _makeAppointment(Meeting meeting, Reserva reserva) async {
    /// consigue el alumno que tiene la sesion iniciada
    final currentStudentEmail = FirebaseAuth.instance.currentUser!.email;
    final alumnoDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentStudentEmail)
        .get();

    /// consigue la clasa seleccionada por el alumno que llega por parametro
    final meetingRef =
        FirebaseFirestore.instance.collection('clases').doc(meeting.id);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final currentMeetingData =
          (await transaction.get(meetingRef)).data() as Map<String, dynamic>;
      if (await _isClassFull(meeting)) {
        if (!context.mounted) return;
        showDialog(context: context, builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Clase llena'),
        ));
      }

      transaction.update(meetingRef, {
        'reservas': FieldValue.arrayUnion([reserva.toMap()]),
        'idAlumno': FieldValue.arrayUnion([currentStudentEmail]),
        // ... Add field to track class fullness  and update based on currentMeetingData, if needed
      });

      transaction.update(alumnoDoc.reference, {
        'clasesReservadas': FieldValue.arrayUnion([meeting.startTime])
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
    /// Instancia la reserva que pasará a _makeAppointment
    Reserva newReserva = Reserva(
      meeting.startTime,
      meeting.endTime,
      FirebaseAuth.instance.currentUser!.email.toString(),
      meeting.id,
    );

    bool isClassFull = await _isClassFull(meeting);
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext buildContext) => AlertDialog(
        backgroundColor: Colors.grey[300],
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
            ),
        ],
      ),
    );
  }

  final double _height = 0.0;
  var myTimezone = 'America/Buenos_Aires';

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
      appointmentTextStyle:  const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      scheduleViewSettings:  const ScheduleViewSettings(
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
      ),
    );
  }
}
