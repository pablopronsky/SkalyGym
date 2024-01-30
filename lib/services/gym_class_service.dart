// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../error/firebase_error.dart';
import '../model/meeting.dart';

class ClaseServicio {
  final CollectionReference meetingsCollection =
      FirebaseFirestore.instance.collection('Meetings');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Meeting>> fetchMeetings() {
    final snapshot =
        FirebaseFirestore.instance.collection('clases').snapshots();
    return snapshot.map((snapshot) =>
        snapshot.docs.map((doc) => Meeting.fromMap(doc.data())).toList());
  }

  Future<void> createSingleClass() async {
    try {
      // Create the class instance with proper date handling
      DateTime classDate = DateTime(2024, 2, 3);
      Meeting meeting = Meeting(
        eventName: 'Clase',
        from: DateTime(classDate.year, classDate.month, classDate.day, 9,
            0), // Combine date and time
        to: DateTime(classDate.year, classDate.month, classDate.day, 10, 0),
        reservas: [],
        idAlumno: [],
        claseLlena: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      );

      CollectionReference classesCollection = _firestore.collection('clases');

      // Use add instead of setData for new documents
      await classesCollection.add(meeting.toMap()).catchError((error) {
        throw FirestoreError('Error adding class to Firestore: $error');
      });
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
