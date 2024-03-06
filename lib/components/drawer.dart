import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym/components/list_tile.dart';

import '../pages/view_model/login_controller.dart';

class MyDrawer extends ConsumerWidget {
  final void Function()? onProfileTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onTap: () =>
                    ref.read(loginControllerProvider.notifier).signOut(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
