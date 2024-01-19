import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUser(String userId) async {
    return await _firestore.collection('alumnos').doc(userId).get();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    return await _firestore.collection('users').doc(userId).update(data);
  }

  Future<void> deleteUser(String userId) async {
    return await _firestore.collection('users').doc(userId).delete();
  }
}