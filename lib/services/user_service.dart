import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {


  static Stream<int> getUserCreditsStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmail)
        .snapshots()
        .map((doc) => doc.get('weeklyCredits') as int);
  }
}
