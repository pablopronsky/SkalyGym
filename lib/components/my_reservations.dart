import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReservationsWidget extends StatefulWidget {
  const MyReservationsWidget({Key? key}) : super(key: key);

  @override
  MyReservationsWidgetState createState() => MyReservationsWidgetState();
}

class MyReservationsWidgetState extends State<MyReservationsWidget> {

  final _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.email;

  Future<void> _cancelReservation(String reservationId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('clasesReservadas')
        .doc(reservationId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Users')
          .doc(userId)
          .collection('clasesReservadas')
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot.data);
        print(userId);

        if (snapshot.hasError) {
          return Text(
              'Ups. Algo salió mal: ${snapshot.error}'); // More descriptive error
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Text('No se encontraron reservas');
        }

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reservationData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final timestampStart = reservationData['startTime'] as Timestamp;
              final dateTimeStart = timestampStart.toDate();

              return ListTile(
                title: Text(
                    DateFormat('EEE, MMM d, h:mm a').format(dateTimeStart)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Eliminar'),
                      onPressed: () =>
                          _cancelReservation(snapshot.data!.docs[index].id),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
