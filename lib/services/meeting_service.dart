import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/meeting.dart';

class MeetingService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime now = DateTime.now();

  final lastDay = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  final _streamController = StreamController<Map<DateTime, List<Meeting>>>();
  final Map<DateTime, List<Meeting>> _events = {};

  Stream<Map<DateTime, List<Meeting>>> get eventsStream =>
      _streamController.stream;

  Future<void> loadFirestoreEvents() async {
    _events.clear();
    final snap = await FirebaseFirestore.instance
        .collection('meetings')
        .withConverter(
            fromFirestore: Meeting.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final event = doc.data();
      final day = DateTime.utc(
          event.startTime.year, event.startTime.month, event.startTime.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }

    _streamController.add(_events);
  }

  List<Meeting> getEventsForTheDay(DateTime day) {
    final events = _events[day] ?? [];
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    return events ?? [];
  }

  void dispose() {
    _streamController.close();
  }
}
