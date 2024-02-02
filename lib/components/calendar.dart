import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/firestore_data_source.dart';

// Crea un nuevo widget llamado CustomCalendar
class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.schedule,
      dataSource: FirestoreStreamDataSource(),
      headerStyle: const CalendarHeaderStyle(
        backgroundColor: Colors.white30,
        textAlign: TextAlign.center,
        textStyle: TextStyle(color: Colors.white),
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
            monthFormat: 'MMMM, yyyy',
            height: 80,
            textAlign: TextAlign.center,
            backgroundColor: Colors.white24,
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
