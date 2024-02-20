import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/snackbar.dart';
import 'package:gym/services/reservation_service.dart';
import 'package:gym/utils/capitalize.dart';
import 'package:intl/intl.dart';

import '../model/meeting.dart';

class MyReservationsComponent extends StatefulWidget {
  const MyReservationsComponent({Key? key}) : super(key: key);

  @override
  MyReservationsComponentState createState() => MyReservationsComponentState();
}

class MyReservationsComponentState extends State<MyReservationsComponent> {
  final _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.email;
  ReservaServicio reservaServicio = ReservaServicio();

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
                  final reservasDate =
                      Meeting.timeStampToDateTime(reservaClaseData['date']);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            'Clase: ${Capitalize.capitalizeFirstLetter(DateFormat('EEEE', 'es_AR').format(reservasDate))}'),
                        subtitle: Text(
                            'Dia: ${DateFormat('dd-MM-yyyy – hh:mm a').format(reservasDate)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.free_cancellation_rounded,
                              color: Colors.red),
                          onPressed: () => reservaServicio.cancelarReserva(
                              snapshot.data!.docs[index].id, userId!, context),
                        ),
                      ),
                      if (index < snapshot.data!.docs.length - 1)
                        const Divider(),
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
