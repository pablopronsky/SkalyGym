import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym/pages/admin_page.dart';
import 'package:gym/pages/auth_page.dart';
import 'package:gym/pages/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/admin_page': (context) => const AdminPage(),
        '/home_page': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
