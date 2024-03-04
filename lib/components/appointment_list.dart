import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/services/booking_service.dart';
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
  BookingService reservaServicio = BookingService();

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
          return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final reservaClaseData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final reservasDate = Meeting.timeStampToDateTime(
                      reservaClaseData['meetingDate']);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            'Clase: ${Capitalize.capitalizeFirstLetter(DateFormat('EEEE', 'es_AR').format(reservasDate))}'),
                        subtitle: Text(
                            'Dia: ${DateFormat('dd-MM-yyyy – hh:mm a').format(reservasDate)}'),
                        trailing: IconButton(
                          tooltip: 'Cancelar',
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.redAccent,),
                          onPressed: () => reservaServicio.cancelarReserva(
                              snapshot.data!.docs[index].id, userId!, context),
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
              ));
        } else {
          return const Text('No se encontraron reservas');
        }
      },
    );
  }
}
