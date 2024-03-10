import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/capitalize.dart';
import 'package:intl/intl.dart';

import '../model/meeting.dart';
import '../utils/color_constants.dart';

class AppointmentsListComponent extends StatefulWidget {
  const AppointmentsListComponent({Key? key}) : super(key: key);

  @override
  AppointmentsListComponentState createState() =>
      AppointmentsListComponentState();
}

class AppointmentsListComponentState extends State<AppointmentsListComponent> {
  final userId = FirebaseAuth.instance.currentUser?.email;
  ReservationService reservaServicio = ReservationService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: reservaServicio.fetchReservations(userId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar reservas: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reservaClaseData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final reservasDate =
                  Meeting.timeStampToDateTime(reservaClaseData['meetingDate']);
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: ListTile(
                      title: Text(
                        Capitalize.capitalizeFirstLetter(
                            DateFormat('EEEE', 'es_AR').format(reservasDate)),
                        style: GoogleFonts.lexend(
                          color: AppColors.fontColorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        // Use a Column for vertical arrangement
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy – hh:mm a')
                                .format(reservasDate),
                            style: GoogleFonts.lexend(
                              color: AppColors.fontColorSecondary,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        tooltip: 'Cancelar',
                        icon: const Icon(
                          CupertinoIcons.delete,
                          color: AppColors.fontColorSecondary,
                          size: 24,
                        ),
                        onPressed: () => reservaServicio.cancelarReserva(
                            snapshot.data!.docs[index].id, userId!, context),
                      ),
                    ),
                  ),
                  if (index < snapshot.data!.docs.length - 1)
                    Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )
                ],
              );
            },
          );
        } else {
          return Text(
            'No se encontraron reservas',
            style: GoogleFonts.lexend(
              color: AppColors.fontColorPrimary,
              fontSize: 16,
            ),
          );
        }
      },
    );
  }
}
