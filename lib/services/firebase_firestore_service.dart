import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialized directly in declaration

  FirebaseService._internal(); // No need for a constructor body now

  factory FirebaseService() {
    return _instance;
  }

  FirebaseFirestore get firestore => _firestore;
}
