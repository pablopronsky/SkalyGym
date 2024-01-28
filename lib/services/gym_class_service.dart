// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/gym_meeting.dart';

class ClaseServicio {

  final CollectionReference meetingsCollection = FirebaseFirestore.instance.collection('Meetings');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Meeting>> fetchMeetings() {
    final snapshot = FirebaseFirestore.instance.collection('clases').snapshots();
    return snapshot.map((snapshot) => snapshot.docs
        .map((doc) => Meeting.fromMap(doc.data()))
        .toList());
  }

  Future<void> createSingleClass() async {
    try {
      // Create the class instance with proper date handling
      DateTime classDate = DateTime(2024, 2, 3);  // Corrected to valid date
      Meeting meeting = Meeting(
        subject: 'Clase',
        fechaEnLaQueTranscurreLaClase: classDate,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
        reservas: [],
        idAlumno: [],
        claseLlena: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      );

      CollectionReference classesCollection = _firestore.collection('clases');
      // ignore: body_might_complete_normally_catch_error
      await classesCollection.add(meeting.toJson()).catchError((error) {
        print('Error adding class to Firestore: $error');
      });
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
