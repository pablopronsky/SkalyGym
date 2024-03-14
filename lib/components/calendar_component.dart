import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/repository/reservation_repository.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/meeting.dart';
import '../model/reservation.dart';
import '../services/meeting_service.dart';
import '../utils/capitalize.dart';
import '../utils/text_constants.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({super.key});
  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Meeting>> _events;
  late StreamSubscription _subscription;
  final MeetingService _meetingService = MeetingService();
  final ReservationRepository _repository = ReservationRepository();
  ReservationService bookingService = ReservationService();
  DateTime today = DateTime.now();

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
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Text(
              'Reservar clase',
              style: GoogleFonts.lexend(
                color: AppColors.backgroundColorDarkMode,
                fontSize: 22,
              ),
            ),
          ),
        ),
        content: isClassFull
            ? Center(
                child: Text(
                  'La clase esta llena',
                  style: GoogleFonts.lexend(
                    color: AppColors.backgroundColorDarkMode,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Center(
                child: Text(
                  'Confirmar reserva el día ${DateFormat('dd/MM').format(meeting.startTime)}, ${DateFormat('HH:mm').format(meeting.startTime)}hs',
                  style: GoogleFonts.lexend(
                    color: AppColors.backgroundColorDarkMode,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.lexend(
                    color: AppColors.textFieldColorDarkMode,
                    fontSize: 17,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              if (!isClassFull)
                TextButton(
                  child: Text(
                    'Reservar',
                    style: GoogleFonts.lexend(
                      color: AppColors.backgroundColorDarkMode,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    bookingService.makeAppointment(
                        context, meeting, newAppointment);
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
        _events = events;
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
      backgroundColor: AppColors.backgroundColorDarkMode,
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          TableCalendar(
            enabledDayPredicate: (day) {
              final now = DateTime.now();
              final todayDate = DateTime(now.year, now.month, now.day);
              final lastEnabledDate = todayDate.add(const Duration(days: 5));
              return day.isAfter(todayDate.subtract(const Duration(days: 1))) &&
                  day.isBefore(lastEnabledDate.add(const Duration(days: 1)));
            },
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: (TextStyle(
                color: AppColors.fontColorPrimaryDarkMode,
              )),
              weekendStyle: (TextStyle(
                color: AppColors.fontColorPrimaryDarkMode,
              )),
            ),
            availableGestures: AvailableGestures.none,
            locale: 'es_ES',
            availableCalendarFormats: const {CalendarFormat.month: 'month'},
            calendarFormat: CalendarFormat.month,
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
                color: AppColors.fontColorPrimaryDarkMode,
                size: 20.0,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.fontColorPrimaryDarkMode,
                size: 20.0,
              ),
            ),
            calendarStyle: const CalendarStyle(
                defaultTextStyle:
                    TextStyle(color: AppColors.fontColorPrimaryDarkMode),
                markersMaxCount: 1,
                markerSize: 4,
                markerDecoration: BoxDecoration(
                  color: AppColors.fontColorPrimaryDarkMode,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentColor,
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontColorPrimaryDarkMode,
                ),
                todayTextStyle: TextStyle(
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.textFieldColorDarkMode,
                  shape: BoxShape.circle,
                )),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                String monthName = Capitalize.capitalizeFirstLetter(
                    DateFormat.MMMM('es_ES').format(day));
                return Text(
                  monthName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    color: AppColors.fontColorPrimaryDarkMode,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // LISTVIEW
          Expanded(
            flex: 1,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:
                  _meetingService.getEventsForTheDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event =
                    _meetingService.getEventsForTheDay(_selectedDay)[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: event.freeSlotsCount > 0
                            ? () {
                                _showAppointmentDialog(context, event);
                              }
                            : null,
                        child: Material(
                          color: AppColors.backgroundColorDarkMode,
                          child: ListTile(
                            title: Text(
                              Capitalize.capitalizeFirstLetter(event.subject),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: AppColors.fontColorPrimaryDarkMode,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy HH:mm')
                                      .format(event.startTime),
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.fontColorPrimaryDarkMode,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 20.0),
                                Opacity(
                                  opacity:
                                      (event.freeSlotsCount < 1) ? 0.2 : 0.7,
                                  child: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColors.fontColorPrimaryDarkMode,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "${TextReplace.calendarFreeSlot}${event.freeSlotsCount}.",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: AppColors.fontColorPrimaryDarkMode,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: AppColors.borderTextFieldDarkMode,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
