import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/pages/profile.dart';

import '../components/drawer.dart';
import 'calendar_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Perfil(),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: SingleChildScrollView(
    child: Column(
    children: <Widget>[
          Container(
            height: 150.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Calendar(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[900],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('Calendario',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const VerticalDivider(
                // Línea divisoria vertical
                color: Colors.grey, // Color de la línea
                width: 1, // Grosor de la línea
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[300],
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text('Mis clases',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 200.0,
            child: Column(
              children: <Widget>[
                Text('Esta semana'),
                ListTile(
                  title: Text('Mar, 7:30 AM'),
                  trailing: Text('Reservado'),
                ),
                ListTile(
                  title: Text('Mié, 9:00 AM'),
                  trailing: Text('Unirse'),
                ),
                ListTile(
                  title: Text('Jue, 6:00 PM'),
                  trailing: Text('Unirse'),
                ),
              ],
            ),
          ),
          const Text('Clases disponibles para reservar:'),
        ],
      ),
    ));
  }
}
