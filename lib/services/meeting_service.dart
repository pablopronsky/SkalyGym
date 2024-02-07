// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../error/firebase_error.dart';
import '../model/meeting.dart';

class MeetingService {
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

  Future<List<Meeting>> getMeetings() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('clases').get();
    return querySnapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();
  }

  Future<void> createSingleClass() async {
    try {
      DateTime classDate = DateTime(2024, 2, 15);
      Meeting meeting = Meeting(
        eventName: 'Clase',
        from: DateTime(classDate.year, classDate.month, classDate.day, 10, 0),
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

  Future<void> createMultipleClasses() async {
    try {
      // Define los horarios
      Map<String, List<List<int>>> horarios = {
        'Lunes': [
          [7, 8],
          [8, 9],
          [9, 10],
          [16, 17],
          [17, 18],
          [18, 19],
          [19, 20],
          [20, 21]
        ],
        'Martes': [
          [16, 17],
          [17, 18],
          [18, 19],
          [19, 20],
          [20, 21]
        ],
        'Miercoles': [
          [7, 8],
          [8, 9],
          [9, 10],
          [16, 17],
          [17, 18],
          [18, 19],
          [19, 20],
          [20, 21]
        ],
        'Jueves': [
          [16, 17],
          [17, 18],
          [18, 19],
          [19, 20],
          [20, 21]
        ],
        'Viernes': [
          [7, 8],
          [8, 9],
          [9, 10],
          [16, 17],
          [17, 18],
          [18, 19],
          [19, 20],
          [20, 21]
        ],
        'Sabado': [
          [7, 8],
          [8, 9],
          [9, 10],
          [10, 11]
        ],
      };

      // Itera sobre los días de la semana
      for (String dia in horarios.keys) {
        // Itera sobre los horarios del día
        for (List<int> horario in horarios[dia]!) {
          // Crea la reunión
          Meeting meeting = Meeting(
            eventName: 'Clase',
            from: DateTime.now().add(Duration(hours: horario[0])),
            to: DateTime.now().add(Duration(hours: horario[1])),
            reservas: [],
            idAlumno: [],
            claseLlena: false,
            recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=10',
          );

          // Agrega la reunión a Firestore
          CollectionReference classesCollection =
              _firestore.collection('clases');
          await classesCollection.add(meeting.toMap()).catchError((error) {
            throw FirestoreError('Error adding class to Firestore: $error');
          });
        }
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
