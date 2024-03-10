import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/pages/profile.dart';
import 'package:gym/utils/color_constants.dart';

import '../components/drawer.dart';
import '../components/appointment_list.dart';
import '../services/user_service.dart';
import '../utils/text_constants.dart';
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
        builder: (context) => const ProfilePage(),
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
      body: Column(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 0,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: SingleChildScrollView(
                child: Container(
                  height: 150.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // TITLE
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      TextReplace.mainTitle,
                      style: GoogleFonts.lexend(
                        color: AppColors.fontColorPrimary,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          const Expanded(
              child: AppointmentsListComponent()
          ),
          Flexible(
            flex: 0,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, right: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Calendar(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor: AppColors.accentColor,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.add,
                              color: AppColors.fontColorPrimary,
                            ),
                            Text(
                              'Reservar',
                              style: GoogleFonts.lexend(
                                color: AppColors.fontColorPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
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
                            padding:
                                const EdgeInsets.only(left: 40, bottom: 15),
                            child: Text(
                              '${TextReplace.mainBottom} ${snapshot.data}',
                              style: GoogleFonts.lexend(
                                fontSize: 16,
                                color: AppColors.fontColorPrimary,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
