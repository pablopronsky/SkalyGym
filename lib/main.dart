import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gym/pages/admin_page.dart';
import 'package:gym/pages/auth_page.dart';
import 'package:gym/pages/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import "package:flutter_localizations/flutter_localizations.dart";



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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
        const Locale('he'),
        const Locale('ru'),
        const Locale('fr', 'BE'),
        const Locale('fr', 'CA'),
        const Locale('ja'),
        const Locale('de'),
        const Locale('hi'),
        const Locale('es'),
      ],
      locale: const Locale('es'),
      routes: {
        '/admin_page': (context) => const AdminPage(),
        '/home_page': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
