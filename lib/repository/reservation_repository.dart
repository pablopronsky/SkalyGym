import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/utils/color_constants.dart';

import '../components/snackbar.dart';
import '../model/meeting.dart';
import '../model/reservation.dart';
import '../pages/my_home_page.dart';

class ReservationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchReservations(String userId) {
    return _firestore
        .collection('reservations')
        .where('userEmail', isEqualTo: userId)
        .snapshots();
  }

  Future<void> makeAppointment(
      BuildContext context, Meeting meeting, Reservation reserva) async {
    final currentStudentEmail = FirebaseAuth.instance.currentUser!.email;

    try {
      await _validateAndReserveAppointment(
          context, meeting, currentStudentEmail!);

      showCustomSnackBar(
        context: context,
        message: 'Reserva creada exitosamente.',
        backgroundColor: AppColors.successColor,
      );
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ));
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: 'Error al crear reserva: $e.',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  Future<void> _createReservation(
      BuildContext context, Meeting meeting, String currentStudentEmail) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentStudentEmail);
      final meetingRef =
          FirebaseFirestore.instance.collection('meetings').doc(meeting.id);

      transaction
          .set(FirebaseFirestore.instance.collection('reservations').doc(), {
        'meetingId': meeting.id,
        'meetingDate': Meeting.dateTimeToTimeStamp(meeting.startTime),
        'userEmail': currentStudentEmail,
        'bookingTimestamp': DateTime.now(),
      });

      transaction.update(meetingRef, {
        'userId': FieldValue.arrayUnion([currentStudentEmail]),
      });

      transaction
          .update(userDocRef, {'weeklyCredits': FieldValue.increment(-1)});
    });
  }

  Future<void> _validateAndReserveAppointment(
      BuildContext context, Meeting meeting, String currentStudentEmail) async {
    if (await isClassFull(meeting)) {
      _handleError(context, 'Clase llena');
      return;
    }

    if (await _hasExistingReservationInClass(meeting.id, currentStudentEmail)) {
      _handleError(context, 'Ya tenes una reserva en esta clase.');
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentStudentEmail)
        .get();

    if (userDoc.get('weeklyCredits') <= 0) {
      _handleError(context, 'No tenes clases disponibles para reservar.');
      return;
    }

    await _createReservation(context, meeting, currentStudentEmail);
  }

  Future<void> cancelReservation(String reservationId, String userId) async {
    try {
      final reservaDoc = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .get();
      final reservaData = reservaDoc.data();
      final classId = reservaData?['meetingId'];

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(reservaDoc.reference);

        if (classId != null) {
          final classDocRef =
              FirebaseFirestore.instance.collection('meetings').doc(classId);
          transaction.update(classDocRef, {
            'userId': FieldValue.arrayRemove([userId]),
          });
        }
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        transaction
            .update(userDocRef, {'weeklyCredits': FieldValue.increment(1)});
      });
    } catch (e) {
      return;
    }
  }

  void _handleError(BuildContext context, String message) {
    if (!context.mounted) return;
    showCustomSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red[400],
    );
  }

  Future<bool> isClassFull(Meeting meeting) async {
    const maxCapacity = 6;

    final reservasCount = await FirebaseFirestore.instance
        .collection('reservations')
        .where('meetingId', isEqualTo: meeting.id) // Filter by classId
        .get()
        .then((snapshot) => snapshot.size);

    return reservasCount >= maxCapacity;
  }

  Future<List<Map<String, dynamic>>> calculateFreeSlotsPerMeeting() async {
    final meetingsCollection =
        FirebaseFirestore.instance.collection('meetings');
    final meetingsSnapshot = await meetingsCollection.get();

    List<Map<String, dynamic>> meetingData = [];

    for (final meetingDoc in meetingsSnapshot.docs) {
      final maxMeetingCapacity = meetingDoc.data()['maxMeetingCapacity'] as int;
      final currentAttendees = meetingDoc.data()['userId'] as List<dynamic>;
      final freeSlots = maxMeetingCapacity - currentAttendees.length;

      meetingData.add({'meetingId': meetingDoc.id, 'freeSlots': freeSlots});
    }
    return meetingData;
  }

  Future<bool> _hasExistingReservationInClass(
      String meetingId, String studentEmail) async {
    final queryResult = await FirebaseFirestore.instance
        .collection('reservations')
        .where('meetingId', isEqualTo: meetingId)
        .where('userEmail', isEqualTo: studentEmail)
        .get();

    return queryResult.size > 0;
  }
}
