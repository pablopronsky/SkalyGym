import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/snackbar.dart';
import '../model/reservation.dart';
import '../model/meeting.dart';
import '../pages/my_home_page.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// This method fetches all reservations with matching userId
  Stream<QuerySnapshot> fetchReservations(String userId) {
    return _firestore
        .collection('reservations')
        .where('userEmail', isEqualTo: userId) // Filter by userId
        .snapshots();
  }

  /// This method creates an appointment (reserva) document, that includes one User and one Meeting.
  Future<void> makeAppointment(
      BuildContext context, Meeting meeting, Reservation reserva) async {
    final currentStudentEmail = FirebaseAuth.instance.currentUser!.email;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentStudentEmail);
    final meetingRef =
        FirebaseFirestore.instance.collection('meetings').doc(meeting.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // 1. Retrieve User Data (including credits)
      final userDoc = await transaction.get(userDocRef);

      if (await isClassFull(meeting)) {
        if (!context.mounted) return;
        showCustomSnackBar(
          context: context,
          message: 'Clase llena',
          backgroundColor: Colors.red[400],
        );
        return;
      }

      // Validation
      if (await _hasExistingReservationInClass(
          meeting.id, currentStudentEmail!)) {
        if (!context.mounted) return;
        showCustomSnackBar(
          context: context,
          message: 'Ya tienes una reserva en esta clase',
          backgroundColor: Colors.red[400],
        );
        return;
      }

      if (userDoc.get('weeklyCredits') <= 0) {
        if (!context.mounted) return;
        showCustomSnackBar(
          context: context,
          message: 'No tenes clases disponibles para reservar.',
          backgroundColor: Colors.red[400],
        );
        return;
      }

      // 4. Create Reservation in 'reservas' Collection
      transaction
          .set(FirebaseFirestore.instance.collection('reservations').doc(), {
        'meetingId': meeting.id,
        'meetingDate': Meeting.dateTimeToTimeStamp(meeting.startTime),
        'userEmail': currentStudentEmail,
        'bookingTimestamp': DateTime.now(),
      });

      // 5. Update Class Document
      transaction.update(meetingRef, {
        'userId': FieldValue.arrayUnion([currentStudentEmail]),
      });

      // 6. Decrement Credits
      transaction
          .update(userDocRef, {'weeklyCredits': FieldValue.increment(-1)});

      if (context.mounted) {
        Navigator.pop(context);
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ));
      showCustomSnackBar(
        context: context,
        message: 'Reserva creada con éxito!',
        backgroundColor: Colors.green[400],
      );
    });
  }

  /// Validate if the class can or cannot have more reservations
  Future<bool> isClassFull(Meeting meeting) async {
    const maxCapacity = 6;

    final reservasCount = await FirebaseFirestore.instance
        .collection('reservations')
        .where('meetingId', isEqualTo: meeting.id) // Filter by classId
        .get()
        .then((snapshot) => snapshot.size);

    return reservasCount >= maxCapacity;
  }

  /// Helper function that returns whether the user has or has not a previous reservation into the selected meeting.
  Future<bool> _hasExistingReservationInClass(
      String classId, String studentEmail) async {
    final queryResult = await FirebaseFirestore.instance
        .collection('reservations')
        .where('meetingId', isEqualTo: classId)
        .where('studentEmail', isEqualTo: studentEmail)
        .get();

    return queryResult.size > 0; // True if a reservation already exists
  }

  /// This method takes a reservaId to delete it, a userId to delete from the Meeting and a context. It literally does what it says.
  Future<void> cancelarReserva(
      String reservationId, String userId, BuildContext context) async {
    bool confirmDeletion = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(
                    child: Text(
                  'Cancelar clase',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('Si',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ],
              );
            }) ??
        false;

    if (!confirmDeletion) return;

    try {
      // Retrieve reservation details (for updating the class)
      final reservaDoc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .get();
      final reservaData = reservaDoc.data();
      final classId = reservaData?['meetingId'];

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Delete reservation from 'reservas'
        transaction.delete(reservaDoc.reference);

        // Update the class document
        if (classId != null) {
          // Ensure classId exists
          final classDocRef =
              FirebaseFirestore.instance.collection('meetings').doc(classId);
          transaction.update(classDocRef, {
            'userId': FieldValue.arrayRemove(
                [userId]), // Assuming userId is accessible
          });
        }
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId); // Ensure userId is accessible
        transaction
            .update(userDocRef, {'weeklyCredits': FieldValue.increment(1)});
      });
      showCustomSnackBar(
        context: context,
        message: 'Reserva eliminada correctamente',
        backgroundColor: Colors.green[400],
      );
    } catch (error) {
      print(error);
      showCustomSnackBar(
        context: context,
        message: 'Error al eliminar la reserva}',
        backgroundColor: Colors.red[400],
      );
    }
  }
}
