// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/appointment.dart';

class ReservaServicio {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> crearReserva(BuildContext context, DateTime startTime,
      DateTime endTime, String idAlumno, String idClase) async {
    // Obtener la referencia de la clase
    DocumentReference claseRef = _firestore.collection('clases').doc(idClase);

    // Obtener la lista de reservas
    QuerySnapshot reservasSnapshot =
        await claseRef.collection('reservas').get();
    List<Object?> reservas =
        reservasSnapshot.docs.map((doc) => doc.data()).toList();

    // Obtener el tamaño de la lista de reservas
    int reservasCount = reservas.length;

    // Validar si el tamaño de la lista de reservas es menor a 6
    if (reservasCount < 6) {
      // Crear la reserva
      Reserva reserva = Reserva(startTime, endTime, idAlumno, idClase);
      await claseRef.collection('reservas').add(reserva.toJson());
    } else {
      // Mostrar un mensaje de error en la pantalla del usuario
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('La clase está llena, busca otra.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      // Setear el atributo "claseLlena" a true
      await claseRef.update({
        'claseLlena': true,
      });
    }
  }
}
