import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/snackbar.dart';
import 'package:gym/pages/my_home_page.dart';
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

  Future<void> _makeAppointment(Meeting meeting, Reserva reserva) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedStartTime = formatter.format(meeting.startTime);
    String formattedNow = formatter.format(DateTime.now());

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

      if (await _isClassFull(meeting)) {
        if (!context.mounted) return;
        showCustomSnackBar(
          context: context,
          message: 'Clase llena',
          backgroundColor: Colors.red[400],
        );
        return;
      }

      /// idReserva = fecha de la clase + fecha en que se hace la reserva + mail del usuario
      final String reservaId = "Reserva: $formattedStartTime, Usuario: ${alumnoDoc.id}, Hecha: $formattedNow";
      /// Crea subcollection
      transaction.set(meetingRef.collection('reservas').doc(reservaId), {
        'classId': meeting.id,
        'date': Meeting.dateTimeToTimeStamp(meeting.startTime),
        'startTime': meeting.startTime,
        'studentEmail': currentStudentEmail,
        'bookedWhen': DateTime.now(),
      });

      transaction.update(meetingRef, {
        'idAlumno': FieldValue.arrayUnion([currentStudentEmail]),
      });

      transaction.set(alumnoDoc.reference.collection('reservas').doc(reservaId), {
        'classId': meeting.id,
        'date': Meeting.dateTimeToTimeStamp(
            meeting.startTime),
        'startTime': meeting.startTime,
      });

      if (mounted) Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ));
      showCustomSnackBar(
        context: context,
        message: 'Reserva creada con éxito!',
        backgroundColor: Colors.green[400],
      );
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
        backgroundColor: Colors.grey[100],
        contentTextStyle: const TextStyle(color: Colors.black),
        title: const Text(
            'Reservar clase'),
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
      ),
    );
  }
}
