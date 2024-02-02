// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/firestore_data_source.dart';
import '../model/meeting.dart';
import '../model/user_client.dart';
import '../services/meeting.dart';
import '../services/user_client_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

 class _HomePageState extends State<HomePage> {
  // vars
  DateTime today = DateTime.now();
  final usuario = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  final ClaseServicio claseServicio = ClaseServicio();
  Stream<List<Meeting>>? meetingsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SfCalendar(
              view: CalendarView.week,
              dataSource: FirestoreDataSource(),
            )
              ],
            )
    );
  }
}
