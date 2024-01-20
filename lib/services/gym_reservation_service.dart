import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/class_reservation.dart';

class ReservaServicio{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> crearReserva(
      String idAlumno,
      String idClase,
      DateTime fechaEnLaQueTranscurreLaReserva,
      TimeOfDay horaDeInicio,
      TimeOfDay horaDeFinalizacion) async {
    try {
      await firestore.collection('reservas').add({
        'idAlumno': idAlumno,
        'idClase': idClase,
        'fechaEnLaQueTranscurreLaReserva':
        fechaEnLaQueTranscurreLaReserva.toIso8601String(),
        'horaDeInicio': {'hour': horaDeInicio.hour, 'minute': horaDeInicio.minute},
        'horaDeFinalizacion': {'hour': horaDeFinalizacion.hour, 'minute': horaDeFinalizacion.minute},
      });
    } catch (error) {
      print('Error al crear reserva: $error');
    }
  }

  Future<Reserva?> obtenerReservaPorId(String id) async {
    try {
      DocumentSnapshot doc = await firestore.collection('reservas').doc(id).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        return Reserva.fromJson(data);
      } else {
        return null;
      }
    } catch (error) {
      print('Error al obtener reserva: $error');
      return null;
    }
  }

  Stream<List<Reserva>> obtenerReservas() {
    return firestore.collection('reservas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Reserva.fromJson(doc.data())).toList();
    });
  }

  Future<void> actualizarReserva(Reserva reserva) async {
    try {
      await firestore.collection('reservas').doc(reserva.id).update(reserva.toJson());
    } catch (error) {
      print('Error al actualizar reserva: $error');
      // Manejar el error de forma adecuada
    }
  }

  Future<void> eliminarReserva(String id) async {
    try {
      await firestore.collection('reservas').doc(id).delete();
    } catch (error) {
      print('Error al eliminar reserva: $error');
      // Manejar el error de forma adecuada
    }
  }
}