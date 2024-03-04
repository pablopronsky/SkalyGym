import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/services/booking_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/meeting.dart';
import '../model/reservation.dart';
import '../services/meeting_service.dart';
import '../utils/capitalize.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({super.key});
  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  Color meetingColor = Colors.transparent;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Meeting>> _events;
  final MeetingService _meetingService = MeetingService();
  late StreamSubscription _subscription;
  BookingService bookingService = BookingService();

  void _fetchMeetingColor() async {
    Color color = await _meetingService.getMeetingColorIndicator(_selectedDay);
    print("$_selectedDay, ${color.toString()}");
    setState(() {
      meetingColor = color;
    });
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

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _meetingService.loadFirestoreEvents();
    _subscription = _meetingService.eventsStream.listen((events) {
      setState(() {
        _events = events; // Update your State variable
      });
    });
    _fetchMeetingColor();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _meetingService.dispose();
    super.dispose();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TableCalendar(
            locale: 'es_ES',
            availableCalendarFormats: const {CalendarFormat.week: 'week'},
            calendarFormat: CalendarFormat.week,
            eventLoader: (day) => _meetingService.getEventsForTheDay(day),
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _meetingService.loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                border: Border(),
                shape: BoxShape.rectangle,
                color: Colors.indigoAccent  ,
              ),
              todayTextStyle: TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                // Customize the header
                String monthName = Capitalize.capitalizeFirstLetter(
                    DateFormat.MMMM('es_ES')
                        .format(day)); // Format and capitalize
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    monthName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _meetingService.getEventsForTheDay(_selectedDay).length,
            itemBuilder: (context, index) {
              final event = _meetingService.getEventsForTheDay(_selectedDay)[index];
              print(_selectedDay);
              return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Material(
                      color: meetingColor,
                      child: ListTile(
                        title: Text(
                          Capitalize.capitalizeFirstLetter(event.subject),
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          DateFormat('dd-MM-yyyy HH:mm').format(event.startTime),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outlined,
                      size: 30,
                      color: Colors.indigoAccent,
                    ),
                    enableFeedback: true,
                    disabledColor: Colors.grey,
                    onPressed: () {
                      _showAppointmentDialog(context, event);
                    },
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
