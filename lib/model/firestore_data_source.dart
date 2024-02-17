import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'meeting.dart'; // Assuming 'meeting.dart' has your Meeting class

class FirestoreStreamDataSource extends CalendarDataSource<Meeting> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _DataSource(List<Meeting> source) {
    appointments = source;
  }

  FirestoreStreamDataSource() {
    firestore.collection('clases').snapshots().listen((eventsSnapshot) {
      final events = eventsSnapshot.docs.map((doc) {
        // Create a Meeting object
        return Meeting(
          id: doc.id, // Assuming your meetings have an 'id' field in Firestore
          subject: doc['subject'], // Use correct Firestore field names
          startTime: doc['startTime'].toDate(),
          endTime: doc['endTime'].toDate(),
        );
      }).toList();

      // Update the appointments list with Meetings
      appointments = events;
      notifyListeners(CalendarDataSourceAction.reset, appointments!);
    });
  }
}
