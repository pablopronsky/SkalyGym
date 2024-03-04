import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/pages/profile.dart';

import '../components/drawer.dart';
import '../components/appointment_list.dart';
import '../services/user_service.dart';
import 'calendar_page.dart';

  class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final currentStudentEmail = FirebaseAuth.instance.currentUser!.email;

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Perfil(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarComponent(),
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Calendar(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: Text('Ver clases disponibles',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 1,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Text(
                      'Mis clases esta semana',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20,),
                    AppointmentsListComponent(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  StreamBuilder<int>(
                      stream:
                          UserService.getUserCreditsStream(currentStudentEmail!),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          return Text(
                              'Clases disponibles para reservar: ${snapshot.data}',
                          );
                        }
                      }),
                ],
              )
            ],
          ),
        ));
  }
}
