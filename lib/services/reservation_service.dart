import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
              return CupertinoAlertDialog(
                title: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                                        'Cancelar reserva',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                    )),
                content: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'No podrás asistir a la clase',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: Opacity(
                          opacity: 0.9,
                          child: Text(
                            'Cerrar',
                            style: Theme.of(context).textTheme.titleSmall
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text(
                          'Confirmar',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
      _repository.cancelReservation(reservationId, userId);
      showCustomSnackBar(
        context: context,
        message: 'Reserva eliminada correctamente',
      );
    } catch (error) {
      showCustomSnackBar(
        context: context,
        message: 'Error al eliminar la reserva}',
      );
    }
  }
}
