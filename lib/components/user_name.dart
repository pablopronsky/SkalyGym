import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _userStream =
      FirebaseFirestore.instance
          .collection('alumnos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching data"));
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.active) {
          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          final nombre = data['nombre'];
          final apellido = data['apellido'];
          return Container(
            color: Colors.grey[900],
            child: Center(
              child: Text(
                '$nombre $apellido',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

}
