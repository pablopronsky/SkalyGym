import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/utils/capitalize.dart';
import 'package:intl/intl.dart';

import '../model/meeting.dart';

class MyReservationsWidget extends StatefulWidget {
  const MyReservationsWidget({Key? key}) : super(key: key);

  @override
  MyReservationsWidgetState createState() => MyReservationsWidgetState();
}

class MyReservationsWidgetState extends State<MyReservationsWidget> {
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
      final reservasDoc = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('reservas')
          .doc(reservasId);

      await reservasDoc.update({'status': 'canceled'});
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

                  return Column( // Wrap ListTile and Divider in a Column
                    children: [
                      ListTile(
                        title: Text('Clase: ${Capitalize.capitalizeFirstLetter(DateFormat('EEEE', 'es_AR').format(reservasDate))}'),
                        subtitle: Text(
                  'Dia: ${DateFormat('dd-MM-yyyy – hh:mm a').format(reservasDate)}'),// Format if needed
                        trailing: IconButton(
                          icon: const Icon(Icons.free_cancellation_rounded,color: Colors.red),
                          onPressed: () =>
                              cancelarReserva(snapshot.data!.docs[index].id),
                        ),
                      ),
                      if (index < snapshot.data!.docs.length - 1) // Add divider only if it's not the last item
                        const Divider() // Add the Divider widget
                    ],
                  );
                },
              )
          );

        } else {
          return const Text('No se encontraron reservas');
        }
      },
    );
  }
}
