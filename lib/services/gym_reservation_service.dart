import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym/error/firebase_error.dart';

import '../model/class_reservation.dart';
import '../model/meeting.dart';

class ReservaServicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> crearReserva(DateTime startTime, DateTime endTime,
      String idAlumno, String idClase, Meeting meeting) async {

    final meetingRef = FirebaseFirestore.instance.collection('clases').doc('mi-clase');
    

    try {
      Reserva reserva = Reserva(startTime, endTime, idAlumno, idClase);

      CollectionReference reservasCollection = _firestore
          .collection('clases')
          .doc(idClase)
          .collection('reservas');

      await reservasCollection.add(reserva.toJson());
    } catch (error) {
      throw FirestoreError(error.toString());
    }
  }
}