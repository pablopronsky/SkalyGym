// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../error/firebase_error.dart';
import '../model/meeting.dart';

class ClaseServicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Meeting>> fetchMeetings() {
    final collection = FirebaseFirestore.instance.collection('clases');

    return collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Meeting.fromMap({
              'eventName': doc.get('eventName'),
              'from': doc.get('from'),
              'to': doc.get('to'),
              'reservas': [].length,
            }))
        .toList());
  }

  Future<void> createSingleClass() async {
    try {
      DateTime classDate = DateTime(2024, 2, 5);
      Meeting meeting = Meeting(
        eventName: 'Clase',
        from: DateTime(classDate.year, classDate.month, classDate.day, 10,
            0),
        to: DateTime(classDate.year, classDate.month, classDate.day, 11, 0),
        reservas: [],
        idAlumno: [],
        claseLlena: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      );

      CollectionReference classesCollection = _firestore.collection('clases');
      await classesCollection.add(meeting.toMap()).catchError((error) {
        throw FirestoreError('Error adding class to Firestore: $error');
      });
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}