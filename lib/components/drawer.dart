import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/list_tile.dart';
import 'package:gym/pages/home_page.dart';
import 'package:gym/pages/profile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                )),
                // home list
                MyListTile(
                  icon: Icons.home,
                  text: 'H O M E',
                  onTap: () => Navigator.pop(context),
                ),
                // profile
                MyListTile(
                  icon: Icons.person,
                  text: 'P E R F I L',
                  onTap: onProfileTap,
                ),
              ],
            ),
            // logout
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: MyListTile(
                icon: Icons.logout,
                text: 'C E R R A R  S E S I O N',
                onTap: onSignOut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
