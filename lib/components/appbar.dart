import 'package:flutter/material.dart';
import 'package:gym/utils/text_constants.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: const Text(
        TextReplace.appBarTitle,
        style: TextStyle(
          fontFamily: 'Airyin',
          fontSize: 50,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      iconTheme: theme.appBarTheme.iconTheme,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
