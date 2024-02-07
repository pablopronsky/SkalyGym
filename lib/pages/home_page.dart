import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/drawer.dart';
import 'package:gym/components/user_name.dart';
import 'package:gym/pages/profile.dart';
import '../components/appbar.dart';
import '../components/calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    void goToProfilePage() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Perfil(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const AppBarComponent(),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: const Column(
        children: [
          SizedBox(
            height: 30,
          ),
          //UserName(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: Calendar()),
          //ListaAlumnos(),
        ],
      ),
    );
  }
}
