// ignore_for_file: avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../error/firebase_error.dart';
import '../model/meeting.dart';

class ClaseServicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Meeting>> fetchMeetings() {
    final collection = FirebaseFirestore.instance.collection('clases');

    // Optimize data retrieval by only fetching required fields
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
      // Create the class instance with proper date handling
      DateTime classDate = DateTime(2024, 2, 3);
      Meeting meeting = Meeting(
        eventName: 'Clase',
        from: DateTime(classDate.year, classDate.month, classDate.day, 10,
            0), // Combine date and time
        to: DateTime(classDate.year, classDate.month, classDate.day, 11, 0),
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
/*
 appBar: AppBar(actions: [
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        )
      ]),

const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              usuario.email!,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 60,
          ),



 const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Alumno>>(
              future: AlumnoServicio().obtenerTodosLosAlumnos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final alumno = snapshot.data![index];
                      return ListTile(
                        title: Text(
                            '${alumno.nombre.toUpperCase()} ${alumno.apellido.toUpperCase()}'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),*/