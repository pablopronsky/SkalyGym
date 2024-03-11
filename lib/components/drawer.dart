import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym/components/list_tile.dart';
import 'package:gym/utils/color_constants.dart';
import 'package:gym/utils/text_constants.dart';
import 'package:gym/providers/theme_provider.dart';

import '../pages/view_model/login_controller.dart';

class MyDrawer extends ConsumerWidget {
  final void Function()? onProfileTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    return Drawer(
      backgroundColor: AppColors.textFieldColor,
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
                  text: TextReplace.drawerFirst,
                  onTap: () => Navigator.pop(context),
                ),
                // profile
                MyListTile(
                  icon: Icons.person,
                  text: TextReplace.drawerSecond,
                  onTap: onProfileTap,
                ),
              ],
            ),
            // logout
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: MyListTile(
                icon: Icons.logout,
                text: TextReplace.drawerLast,
                onTap: () =>
                    ref.read(loginControllerProvider.notifier).signOut(),
              ),
            ),
            Switch(
              value: tSwitchProvider,
              onChanged: (value) {
                ref.read(themeSwitchProvider.notifier).state = value;
              },
            )
          ],
        ),
      ),
    );
  }
}
