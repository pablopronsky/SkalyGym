import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MyHomePageState extends State<MyHomePage>{
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //FOTO
              Container(
                height: 150.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // TITLE
              const SizedBox(height: 20,),
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
                      child:  Center(
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
              // APPOINTMENT LIST
              const AppointmentsListComponent(),
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Calendar(),
                        ),
                      );

                    },
                    child: const Icon(
                      CupertinoIcons.calendar_circle,
                      size: 100,
                      color: AppColors.accentColor,
                    ),
                  ),),
                    ],
                  ),
                ),
                // ICON NAVIGATOR
              // BOTTOM TEXT
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  '${TextReplace.mainBottom} ${snapshot.data}',
                                  style: GoogleFonts.lexend(
                                    fontSize: 16,
                                    color: AppColors.fontColorPrimary,
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
