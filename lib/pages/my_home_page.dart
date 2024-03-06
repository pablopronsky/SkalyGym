import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/pages/profile.dart';
import 'package:gym/utils/constants.dart';

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
        backgroundColor: AppColors.backgroundColor,
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
                        decoration: const BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Center(
                          child: Text('Ver clases disponibles',
                              style: TextStyle(
                                color: AppColors.fontColor,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
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
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.fontColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AppointmentsListComponent(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    // Introduce a Row
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<int>(
                          stream: UserService.getUserCreditsStream(
                              currentStudentEmail!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  'Clases disponibles para reservar: ${snapshot.data}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.fontColor,
                                  ),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
