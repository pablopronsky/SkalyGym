import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

    /// fetch user weeklyCredits from firebase
  static Stream<int> getUserCreditsStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .snapshots()
        .map((doc) => doc.get('weeklyCredits') as int);
  }
}
