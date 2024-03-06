import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym/pages/calendar_page.dart';
import 'package:gym/pages/login_page.dart';
import 'package:gym/pages/my_home_page.dart';
import 'package:gym/pages/profile.dart';
import 'package:gym/pages/register_page.dart';
import 'package:gym/pages/view_model/auth_check.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:flutter_localizations/flutter_localizations.dart";

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //MeetingService meetingService = MeetingService();
  //meetingService.createMultipleClasses();
  initializeDateFormatting()
      .then((_) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
      ],
      locale: const Locale('es'),
      routes: {
        '/home_page': (context) => const MyHomePage(),
        '/profile': (context) => const Perfil(),
        '/calendar': (context) => const Calendar(),
        '/register_page': (context) => const RegisterPage(),
        '/login_page': (context) => const LoginPage(),
        'auth_check': (context) => const AuthChecker(),
      },
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
    );
  }
}
