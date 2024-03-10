import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gym/repository/reservation_repository.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/color_constants.dart';
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
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Reservar clase',
              style: TextStyle(
                color: AppColors.backgroundColor,
                fontSize: 20,
              ),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: isClassFull
              ? const Center(
                  child: Text(
                    'La clase esta llena',
                    style: TextStyle(color: AppColors.blackColor),
                  ),
                )
              : Center(
                  child: Text(
                    'Confirmar reserva el día ${DateFormat('dd/MM').format(meeting.startTime)}, ${DateFormat('HH:mm').format(meeting.startTime)}hs',
                    style: const TextStyle(
                        color: AppColors.blackColor, fontSize: 16, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        // actionsPadding: const EdgeInsets.all(12.0), // Add padding
        actions: <Widget>[
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Use spaceBetween
            children: [
              TextButton(
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.backgroundColor,
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
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold,
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
                color: AppColors.fontColorPrimary,
              )),
              weekendStyle: (TextStyle(
                color: AppColors.fontColorPrimary,
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
            headerStyle: const HeaderStyle(
              leftChevronIcon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 20.0,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: AppColors.fontColorPrimary),
                markersMaxCount: 1,
                markerSize: 4,
                markerDecoration: BoxDecoration(
                  color: AppColors.fontColorPrimary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentColor,
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontColorPrimary,
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
                      color: AppColors.fontColorPrimary,
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
          // LISTVIEW
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
                              fontSize: 18, color: AppColors.fontColorPrimary),
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
                                color: AppColors.fontColorPrimary,
                              ),
                            ),
                            Text(
                              "Cupos libres: ${event.freeSlotsCount}.",
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.fontColorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: event.freeSlotsCount > 0
                        ? (event.freeSlotsCount == 1
                            ? Image.asset('assets/icon_half.png', height: 30)
                            : Image.asset('assets/icon_empty.png', height: 30))
                        : Image.asset('assets/icon_full.png', height: 30),
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
