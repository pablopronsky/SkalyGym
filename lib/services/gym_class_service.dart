import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/gym_class.dart';
import 'firebase_firestore_service.dart';

class ClaseServicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Use instance directly

  Future<void> createSingleClass() async {
    // Create the class instance
    DateTime classDate = DateTime(2024, 2, 29); // Set specific date
    Clase clase = Clase(classDate, const TimeOfDay(hour: 9, minute: 0),const TimeOfDay(hour: 10, minute: 0),
      [], false, [],null,
    );

    // Add the class to Firestore
    CollectionReference classesCollection = _firestore.collection('clases');
    await classesCollection.add(clase.toJson());
  }
}
