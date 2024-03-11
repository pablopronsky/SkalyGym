import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/snackbar.dart';
import '../model/reservation.dart';
import '../model/meeting.dart';
import '../repository/reservation_repository.dart';
import '../utils/color_constants.dart';

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
                    child: Text(
                  'Cancelar reserva',
                  style: GoogleFonts.lexend(
                    color: AppColors.backgroundColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                content: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Si cancelas no podrás asistir a la clase',
                    style: GoogleFonts.lexend(
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: Text(
                          'Cerrar',
                          style: GoogleFonts.lexend(
                            color: AppColors.textFieldColor,
                            fontSize: 17,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: Text(
                          'Confirmar',
                          style: GoogleFonts.lexend(
                            color: AppColors.backgroundColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
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
