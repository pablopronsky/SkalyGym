import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/snackbar.dart';
import '../model/reservation.dart';
import '../model/meeting.dart';
import '../repository/reservation_repository.dart';

class ReservationService {
  final ReservationRepository _repository = ReservationRepository();

  /// This method fetches all reservations with matching userId
  Stream<QuerySnapshot> fetchReservations(String userId) {
    return _repository.fetchReservations(userId);
  }

  /// This method creates an appointment (reserva) document, that includes one User and one Meeting.
  Future<void> makeAppointment(
      BuildContext context, Meeting meeting, Reservation reserva) async {
    return _repository.makeAppointment(context, meeting, reserva);
  }

  /// Validate if the class can or cannot have more reservations
  Future<bool> isClassFull(Meeting meeting) async {
    return _repository.isClassFull(meeting);
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
      _repository.cancelReservation(reservationId, userId, context);
      showCustomSnackBar(
        context: context,
        message: 'Reserva eliminada correctamente',
        backgroundColor: Colors.green[400],
      );
    } catch (error) {
      showCustomSnackBar(
        context: context,
        message: 'Error al eliminar la reserva}',
        backgroundColor: Colors.red[400],
      );
    }
  }
}
