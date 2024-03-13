import 'package:flutter/material.dart';
import 'package:gym/utils/text_constants.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        TextReplace.appBarTitle,
        style: theme.textTheme.titleLarge,
      ),
      centerTitle: true,
      iconTheme: theme.appBarTheme.iconTheme,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}