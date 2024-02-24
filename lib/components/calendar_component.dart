import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/reservation.dart';
import '../model/firestore_data_source.dart';
import '../model/meeting.dart';
import '../services/reservation_service.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  BookingService bookingService = BookingService();

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      final Meeting tappedMeeting = calendarTapDetails.appointments!.first;
      _showAppointmentDialog(context, tappedMeeting);
    }
  }

  void _showAppointmentDialog(BuildContext context, Meeting meeting) async {
    /// This is the appointment that is sent to appointmentService.createAppointment
    Reservation newAppointment = Reservation(
      meeting.startTime,
      meeting.endTime,
      FirebaseAuth.instance.currentUser!.email.toString(),
      meeting.id,
    );

    bool isClassFull = await bookingService.isClassFull(meeting);
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext buildContext) => AlertDialog(
        backgroundColor: Colors.grey[100],
        contentTextStyle: const TextStyle(color: Colors.black),
        title: const Text('Reservar clase'),
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
                bookingService.makeAppointment(
                    context, meeting, newAppointment);
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
        backgroundColor: Colors.blueAccent,
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
