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
  late ThemeData currentTheme;

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
              style: currentTheme.textTheme.bodyLarge,
            ),
          ),
        ),
        content: isClassFull
            ? Center(
                child: Text(
                  'La clase esta llena',
                  style: GoogleFonts.lexend(
                    color: AppColors.fillGreyAmbiguousColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Center(
                child: Text(
                  'Confirmar reserva el día ${DateFormat('dd/MM').format(meeting.startTime)}, ${DateFormat('HH:mm').format(meeting.startTime)}hs',
                  style: currentTheme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Opacity(
                  opacity: 0.9,
                  child: Text(
                    'Cancelar',
                    style: currentTheme.textTheme.titleSmall,
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
                    style: currentTheme.textTheme.bodyMedium,
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
    currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
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
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: (currentTheme.textTheme.bodyMedium) ??
                  const TextStyle(color: AppColors.fillGreyAmbiguousColor),
              weekendStyle: (currentTheme.textTheme.bodyMedium) ??
                  const TextStyle(color: AppColors.fillGreyAmbiguousColor),
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
              // DISABLED
              leftChevronIcon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.fillGreyAmbiguousColor,
                size: 0.0,
              ),
              // DISABLED
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.fillGreyAmbiguousColor,
                size: 0.0,
              ),
              headerPadding: EdgeInsets.all(8),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: (currentTheme.textTheme.bodyMedium) ??
                  const TextStyle(color: AppColors.dividerGrey),
              markersMaxCount: 0,
              selectedTextStyle: GoogleFonts.montserrat(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
              ),
              todayTextStyle: GoogleFonts.montserrat(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.accentColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: AppColors.fillGreyAmbiguousColorLight,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                String monthName = Capitalize.capitalizeFirstLetter(
                    DateFormat.MMMM('es_ES').format(day));
                return Text(
                  monthName,
                  textAlign: TextAlign.center,
                  style: currentTheme.textTheme.labelLarge,
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
              child: ListView.builder(
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
                            color: currentTheme.scaffoldBackgroundColor,
                            child: ListTile(
                              leading: SizedBox(
                                width: 40,
                                child: Image.asset(
                                  'lib/assets/logo_ skaly.png',
                                  color:
                                      currentTheme.brightness == Brightness.dark
                                          ? AppColors.fontColorPrimaryDarkMode
                                          : AppColors.fontColorPrimaryLightMode,
                                ),
                              ),
                              title: Text(
                                Capitalize.capitalizeFirstLetter(event.subject),
                                style: currentTheme.textTheme.displayMedium,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    (event.freeSlotsCount >= 1)
                                        ? "${TextReplace.calendarFreeSlot}${event.freeSlotsCount}"
                                        : TextReplace.calendarFullMeeting,
                                    style: currentTheme.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                DateFormat('dd-MM-yyyy HH:mm')
                                    .format(event.startTime),
                                style: currentTheme.textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
