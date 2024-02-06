import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'meeting.dart';

class FirestoreStreamDataSource extends CalendarDataSource<Meeting> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _DataSource(List<Meeting> source) {
    appointments = source;
  }

  FirestoreStreamDataSource() {
    firestore.collection('clases').snapshots().listen((eventsSnapshot) {
      final events = eventsSnapshot.docs.map((doc) {
        return Appointment(
          startTime: doc['from'].toDate(),
          endTime: doc['to'].toDate(),
          subject: doc['eventName'],
        );
      }).toList();

      // Update the appointments list
      appointments = events;
      notifyListeners(CalendarDataSourceAction.reset, appointments!);
    });
  }
}
