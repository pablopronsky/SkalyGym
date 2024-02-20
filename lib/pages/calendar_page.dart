import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/calendar_component.dart';
import '../components/appbar.dart';

/// This page renders and appBar along with the CalendarComponent.
class Calendar extends StatelessWidget {
  const Calendar({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const AppBarComponent(),
      body: const Column(
        children: [
          Expanded(child: CalendarComponent()),
        ],
      ),
    );
  }
}
