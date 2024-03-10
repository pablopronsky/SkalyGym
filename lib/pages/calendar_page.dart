import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/appbar.dart'; // Assuming your button widget is here
import '../components/calendar_component.dart';

/// This page renders and appBar along with the CalendarComponent.
class Calendar extends StatelessWidget {
  const Calendar({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComponent(),
      body: Column(
        children: [
          Expanded(
            child: CalendarComponent(),
          ),
        ],
      ),
    );
  }
}
