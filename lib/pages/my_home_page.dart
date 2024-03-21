import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/pages/profile.dart';
import 'package:gym/utils/color_constants.dart';
import 'package:showcaseview/showcaseview.dart';

import '../components/calendar_component.dart';
import '../components/drawer.dart';
import '../components/appointment_list.dart';
import '../services/user_service.dart';
import '../utils/text_constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final currentStudentEmail = FirebaseAuth.instance.currentUser!.email;
  final _reservationList = GlobalKey();
  final _calendarButton = GlobalKey();
  final _userFreeSlots = GlobalKey();
  late ThemeData currentTheme;
  late List<GlobalKey> keyList;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([
              _reservationList,
              _calendarButton,
              _userFreeSlots,
            ]));
    super.initState();
  }

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
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: const AppBarComponent(),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
      ),
      body: Column(
        children: <Widget>[
          // IMAGE
          Flexible(
            fit: FlexFit.tight,
            flex: 0,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: SingleChildScrollView(
                child: Container(
                  height: 180.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/home_background.jpg'),
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
          // TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      TextReplace.homeTitle,
                      style: currentTheme.textTheme.headlineLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          // LIST OF APPOINTMENTS
          Expanded(
            child: Showcase(
                targetBorderRadius: BorderRadius.circular(8),
                key: _reservationList,
                description: TextReplace.homeReservationList,
                descriptionAlignment: TextAlign.center,
                child: const AppointmentsListComponent()),
          ),
          const SizedBox(height: 30),
          // BUTTON TO CALENDAR PAGE
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
                      padding: const EdgeInsets.only(bottom: 50.0, right: 40),
                      child: Showcase(
                        key: _calendarButton,
                        description: TextReplace.homeCalendarButton,
                        descriptionAlignment: TextAlign.center,
                        targetBorderRadius: BorderRadius.circular(25),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CalendarComponent(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: AppColors.accentColor,
                            enableFeedback: true,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                TextReplace.homeGoToButton,
                                style: GoogleFonts.lexend(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // REMAINING CLASSES
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
                                const EdgeInsets.only(left: 20, bottom: 15),
                            child: Showcase(
                              key: _userFreeSlots,
                              description: TextReplace.homeFreeSlots,
                              descriptionAlignment: TextAlign.center,
                              targetBorderRadius: BorderRadius.circular(15),
                              targetPadding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              child: Text(
                                '${TextReplace.homeFooter} ${snapshot.data}',
                                style: currentTheme.textTheme.bodyMedium,
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
