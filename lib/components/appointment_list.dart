import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/capitalize.dart';
import 'package:intl/intl.dart';

import '../model/meeting.dart';

class AppointmentsListComponent extends StatefulWidget {
  const AppointmentsListComponent({Key? key}) : super(key: key);

  @override
  AppointmentsListComponentState createState() =>
      AppointmentsListComponentState();
}

class AppointmentsListComponentState extends State<AppointmentsListComponent> {
  final userId = FirebaseAuth.instance.currentUser?.email;
  ReservationService reservaServicio = ReservationService();
  late ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: reservaServicio.fetchReservations(userId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar reservas: ${snapshot.error}',
                  style: currentTheme.textTheme.bodyLarge),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reservations = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              reservations.sort((a, b) {
                DateTime dateTimeA =
                    Meeting.timeStampToDateTime(a['meetingDate']);
                DateTime dateTimeB =
                    Meeting.timeStampToDateTime(b['meetingDate']);
                return dateTimeA.compareTo(dateTimeB);
              });
              final reservaClaseData = reservations[index];
              final reservasDate =
                  Meeting.timeStampToDateTime(reservaClaseData['meetingDate']);
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              Capitalize.capitalizeFirstLetter(
                                DateFormat('EEEE', 'es_AR')
                                    .format(reservasDate),
                              ),
                              style: currentTheme.textTheme.bodyMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy – hh:mm a')
                                      .format(reservasDate),
                                  style: currentTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              tooltip: 'Cancelar',
                              icon: const Icon(
                                CupertinoIcons.delete,
                                size: 20,
                              ),
                              color: currentTheme.iconTheme.color,
                              onPressed: () => reservaServicio.cancelarReserva(
                                snapshot.data!.docs[index].id,
                                userId!,
                                context,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < snapshot.data!.docs.length - 1)
                    Divider(
                      thickness: 0.4,
                      color: currentTheme.dividerColor,
                    )
                ],
              );
            },
          );
        } else {
          return Text(
            'No se encontraron reservas',
            style: currentTheme.textTheme.bodyMedium,
          );
        }
      },
    );
  }
}
