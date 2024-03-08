import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/repository/reservation_repository.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/constants.dart';
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
  ReservationService bookingService = ReservationService();
  final ReservationRepository _repository = ReservationRepository();

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
      builder: (BuildContext context) => AlertDialog(
        titlePadding:
            const EdgeInsets.only(top: 16.0, bottom: 8.0), // Adjust padding
        title: const Center(
          child: Text(
            'Reservar clase',
            style: TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold, // Bold the title
              fontSize: 20, // Increase font size
            ),
          ),
        ),
        content: SingleChildScrollView(
          // For potential overflow
          child: isClassFull
              ? const Center(
                  // Center if content fits
                  child: Text(
                    'La clase esta llena',
                    style: TextStyle(color: AppColors.blackColor),
                  ),
                )
              : Center(
                  child: Text(
                    'Confirmar reserva el día ${DateFormat('dd/MM').format(meeting.startTime)}, ${DateFormat('HH:mm').format(meeting.startTime)}hs',
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        actionsPadding: const EdgeInsets.all(12.0), // Add padding
        actions: <Widget>[
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Use spaceBetween
            children: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              if (!isClassFull)
                TextButton(
                  child: const Text(
                    'Reservar',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
                    bookingService.makeAppointment(
                        context, meeting, newAppointment);
                    Navigator.pop(context);
                  },
                ),
            ],
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
    _firstDay = DateTime.now().subtract(const Duration(days: 0));
    _lastDay = DateTime.now().add(const Duration(days: 7));
    _selectedDay = DateTime.now();
    _meetingService.loadFirestoreEvents();
    _subscription = _meetingService.eventsStream.listen((events) {
      setState(() {
        _events = events; // Update your State variable
      });
    });
    _repository.calculateFreeSlotsPerMeeting();
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
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TableCalendar(
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: (TextStyle(
                color: AppColors.fontColor,
              )),
              weekendStyle: (TextStyle(
                color: AppColors.fontColor,
              )),
            ),
            availableGestures: AvailableGestures.none,
            locale: 'es_ES',
            availableCalendarFormats: const {CalendarFormat.week: 'week'},
            calendarFormat: CalendarFormat.week,
            eventLoader: (day) => _meetingService.getEventsForTheDay(day),
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            weekendDays: const [DateTime.sunday],
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
            headerStyle: HeaderStyle(
                decoration: BoxDecoration(
              //color: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(3),
            )),
            calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: AppColors.fontColor),
                markersMaxCount: 1,
                markerDecoration: BoxDecoration(
                  color: AppColors.fontColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentColor,
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontColor,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  shape: BoxShape.circle,
                )),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                String monthName = Capitalize.capitalizeFirstLetter(
                    DateFormat.MMMM('es_ES').format(day));
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    monthName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.fontColor,
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
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _meetingService.getEventsForTheDay(_selectedDay).length,
            itemBuilder: (context, index) {
              final event =
                  _meetingService.getEventsForTheDay(_selectedDay)[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Material(
                      color: meetingColor,
                      child: ListTile(
                        title: Text(
                          Capitalize.capitalizeFirstLetter(event.subject),
                          style: const TextStyle(
                              fontSize: 18, color: AppColors.fontColor),
                        ),
                        subtitle: Column(
                          // Using a Column for better layout
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy HH:mm')
                                  .format(event.startTime),
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.fontColor,
                              ),
                            ),
                            Text(
                              "Cupos libres: ${event.freeSlotsCount}.",
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.fontColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.event_available,
                      size: 30,
                      color: event.freeSlotsCount > 0
                          ? event.freeSlotsCount == 1
                              ? Colors.yellowAccent
                              : Colors.green
                          : Colors.grey,
                    ),
                    tooltip: event.freeSlotsCount > 0
                        ? 'Reservar'
                        : 'Clase completa',
                    enableFeedback: true,
                    onPressed: event.freeSlotsCount > 0
                        ? () {
                            _showAppointmentDialog(context, event);
                          }
                        : null,
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.accentColor,
            ),
          )
        ],
      ),
    );
  }
}
