import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/snackbar.dart';
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

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> fetchReservations(String userId) {
      return _firestore
          .collection('Users')
          .doc(userId)
          .collection('reservas')
          .where('status', isEqualTo: 'active')
          .snapshots();
    }

    Future<void> cancelarReserva(String reservasId) async {
      bool confirmDeletion = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(
                      child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cancelar clase',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text('No',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              )),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text('Si',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
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
        final reservasDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('reservas')
            .doc(reservasId);

        await reservasDoc.delete();

        showCustomSnackBar(
          context: context,
          message: 'Reserva eliminada correctamente',
          backgroundColor: Colors.green[400],
        );
      } catch (error) {
        showCustomSnackBar(
          context: context,
          message: 'Error al eliminar la reserva',
          backgroundColor: Colors.red[400],
        );
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: fetchReservations(userId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching reservations: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return SizedBox(
              height: 250, // Adjust the height as needed
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final reservasData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final reservasDate =
                      Meeting.timeStampToDateTime(reservasData['date']);

                  return Column(
                    // Wrap ListTile and Divider in a Column
                    children: [
                      ListTile(
                        title: Text(
                            'Clase: ${Capitalize.capitalizeFirstLetter(DateFormat('EEEE', 'es_AR').format(reservasDate))}'),
                        subtitle: Text(
                            'Dia: ${DateFormat('dd-MM-yyyy – hh:mm a').format(reservasDate)}'), // Format if needed
                        trailing: IconButton(
                          icon: const Icon(Icons.free_cancellation_rounded,
                              color: Colors.red),
                          onPressed: () =>
                              cancelarReserva(snapshot.data!.docs[index].id),
                        ),
                      ),
                      if (index <
                          snapshot.data!.docs.length -
                              1) // Add divider only if it's not the last item
                        const Divider() // Add the Divider widget
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
