import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/gym_class.dart';
import 'firebase_firestore_service.dart';

class ClaseServicio {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseService().firestore;

  Future<void> persistirClase(Clase clase) async {
    CollectionReference clasesRef = _firestore.collection('clases');
    DocumentReference docRef = clasesRef.doc();

    await docRef.set(clase.toJson());

    clase.id = docRef.id;
  }

  Future<void> createClase(Clase clase) async {
    await _firebaseService.firestore.collection('clases').add(clase.toJson());
  }

  Future<List<Clase>> getClases() async {
    QuerySnapshot querySnapshot =
        await _firebaseService.firestore.collection('clases').get();
    return querySnapshot.docs
        .map((doc) => Clase.fromJson(doc.data()! as Map<String, dynamic>))
        .toList();
  }

  Future<Clase?> getClaseById(String id) async {
    DocumentSnapshot doc =
        await _firebaseService.firestore.collection('clases').doc(id).get();
    if (doc.exists) {
      return Clase.fromJson(doc.data()! as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updateClase(Clase clase) async {
    await _firebaseService.firestore
        .collection('clases')
        .doc(clase.id)
        .update(clase.toJson());
  }

  Future<void> deleteClase(String id) async {
    await _firebaseService.firestore.collection('clases').doc(id).delete();
  }

}
