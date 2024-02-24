import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meeting.dart';

class FirestoreStreamDataSource extends CalendarDataSource<Meeting> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _DataSource(List<Meeting> source) {
    appointments = source;
  }

  FirestoreStreamDataSource() {
    firestore.collection('meetings').snapshots().listen((eventsSnapshot) {
      final events = eventsSnapshot.docs.map((doc) {
        return Meeting(
          id: doc.id,
          subject: doc['subject'],
          startTime: doc['startTime'].toDate(),
          endTime: doc['endTime'].toDate(),
        );
      }).toList();

      appointments = events;
      notifyListeners(CalendarDataSourceAction.reset, appointments!);
    });
  }
}
