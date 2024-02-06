import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/firestore_data_source.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      _showDialog(calendarTapDetails);
    }
  }

  _showDialog(CalendarTapDetails details) async {
    Appointment appointment = details.appointments![0];
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final String fecha =
            '${appointment.startTime.year}-${appointment.startTime.month.toString().padLeft(2, '0')}-${appointment.startTime.day.toString().padLeft(2, '0')}';
        final String horaInicio =
            DateFormat('hh:mm a').format(appointment.startTime);
        final String horaFin =
            DateFormat('hh:mm a').format(appointment.endTime);

        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text(
            "Clase seleccionada",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                const TextSpan(
                    text: 'FECHA: ', style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: "$fecha\n",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                WidgetSpan(
                    child: SizedBox(height: 10)), // Increase vertical space
                const TextSpan(
                    text: 'HORA DE INICIO: ',
                    style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: "$horaInicio\n",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                WidgetSpan(
                    child: SizedBox(height: 10)), // Increase vertical space
                const TextSpan(
                    text: 'HORA DE FIN: ',
                    style: TextStyle(color: Colors.white)),
                TextSpan(
                    text: "$horaFin\n",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  final double _height = 0.0;

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
      view: CalendarView.schedule,
      dataSource: FirestoreStreamDataSource(),
      onTap: calendarTapped,
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: Colors.white30,
        textAlign: TextAlign.center,
        textStyle: TextStyle(color: Colors.white),
      ),
      monthViewSettings:
          MonthViewSettings(showAgenda: true, agendaViewHeight: _height),
      timeZone: 'Argentina Standard Time',
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
