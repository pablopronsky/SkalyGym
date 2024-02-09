import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_or_register.dart';
import 'my_home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // logeado
            if (snapshot.hasData) {
              return const MyHomePage();
            }
            // no loggeado
            else {
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}
