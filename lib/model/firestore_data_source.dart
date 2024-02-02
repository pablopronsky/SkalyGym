import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class FirestoreDataSource extends CalendarDataSource {
  @override
  List<Appointment> get appointments => _appointments;
  List<Appointment> _appointments = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirestoreDataSource() {
    fetchEvents().then((events) {
      _appointments = events;
      notifyListeners(CalendarDataSourceAction.reset, _appointments); // Provide both arguments
    });
  }

  // Function to refresh events on demand
  Future<void> refreshEvents() async {
    _appointments = await fetchEvents();
    notifyListeners(CalendarDataSourceAction.reset, _appointments); // Provide both arguments
  }

  Future<List<Appointment>> fetchEvents() async {
    final eventsSnapshot = await firestore.collection('clases').get();
    final events = eventsSnapshot.docs.map((doc) {
      return Appointment(
        startTime: doc['from'].toDate(),
        endTime: doc['to'].toDate(),
        subject: doc['eventName'],
      );
    }).toList();
    return events;
  }
}
