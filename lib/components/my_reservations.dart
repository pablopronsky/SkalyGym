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
          .snapshots();
    }

    Future<void> cancelarReserva(String reservasId) async {
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
                          child: const Text('No',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),),
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
        // RESERVAS DEL USUARIO COLLECTION
        final reservasUserDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('reservas')
            .doc(reservasId);
        final reservaUserData = (await reservasUserDoc.get()).data();
        final classId = reservaUserData?['classId'];

        // RESERVAS EN LA CLASE COLLECTION
        final reservasClaseDoc = FirebaseFirestore.instance
            .collection('clases')
            .doc(classId)
            .collection('reservas')
            .doc(reservasId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Delete reservation from user
          transaction.delete(reservasUserDoc);
          transaction.delete(reservasClaseDoc);

          // Update the class document
          final classDocRef = FirebaseFirestore.instance.collection('clases').doc(classId);
          transaction.update(classDocRef, {
            'idAlumno': FieldValue.arrayRemove([userId]),
          });
        await reservasClaseDoc.delete();
        });

        showCustomSnackBar(
          context: context,
          message: 'Reserva eliminada correctamente',
          backgroundColor: Colors.green[400],
        );
      } catch (error) {
        print(error);
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
                          onPressed: () =>
                              cancelarReserva(snapshot.data!.docs[index].id),
                        ),
                      ),
                      if (index <
                          snapshot.data!.docs.length -
                              1)
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
