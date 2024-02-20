import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/meeting.dart';

class MeetingService {

  Future<List<Meeting>> getMeetings() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('meetings').get();
    return querySnapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();
  }

}
