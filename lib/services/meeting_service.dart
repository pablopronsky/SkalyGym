import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return _events[day] ?? [];
  }

  Future<Color> getMeetingColorIndicator(DateTime day) async {
    // Construct the start and end of the day for the query
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

    // Query Firestore for meetings within the day
    QuerySnapshot querySnapshot = await firestore.collection('meetings')
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThanOrEqualTo: endOfDay)
        .get();

    // Count total participants across qualifying meetings
    int totalParticipants = 0;
    for (final doc in querySnapshot.docs) {
      final userIds = doc.get('userId') as List;
      totalParticipants += userIds.length;
    }
    // Determine color based on participant count
    if (totalParticipants < 4) {
      return Colors.lightGreenAccent;
    } else if (totalParticipants == 5) {
      return Colors.yellowAccent;
    } else { // 6 or more
      return Colors.redAccent;
    }
  }


  void dispose() {
    _streamController.close();
  }
}
