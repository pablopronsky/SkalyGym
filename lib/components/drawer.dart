import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gym/components/list_tile.dart';
import 'package:gym/main.dart';
import 'package:gym/utils/text_constants.dart';

import '../pages/view_model/login_controller.dart';
import '../utils/color_constants.dart';

class MyDrawer extends ConsumerWidget {
  final void Function()? onProfileTap;

  const MyDrawer({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Other Drawer Content
            Column(
              children: [
                DrawerHeader(
                    child: IconTheme(
                  data: Theme.of(context).iconTheme,
                  child: const Icon(
                    Icons.person,
                    size: 64,
                  ),
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
            // Expanded to push content towards the top
            Expanded(child: Container()),
            //Logout
            Column(
              children: [
                // Theme switch
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /* Text(
                        ref.watch(themeSwitchProvider) ? TextReplace.drawerThemeModeLight : TextReplace.drawerThemeModeDark,
                        style: TextStyle(fontSize: 15,),
                      ),*/
                      Transform.scale(
                        scale: 0.95,
                        child: FlutterSwitch(
                          value: ref.watch(themeNotifierProvider).isDarkMode,
                          onToggle: (value) {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .toggleThemeMode();
                          },
                          activeIcon: const Icon(
                            Icons.dark_mode_outlined,
                            color: AppColors.fontColorPrimaryDarkMode,
                            weight: 13,
                          ),
                          activeColor: AppColors.accentColor,
                          inactiveIcon: const Icon(
                            Icons.light_mode_outlined,
                            color: AppColors.fontColorPrimaryDarkMode,
                          ),
                          inactiveColor: AppColors.accentColor,
                          toggleColor: Theme.of(context).disabledColor,
                        ),
                      )
                    ],
                  ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
