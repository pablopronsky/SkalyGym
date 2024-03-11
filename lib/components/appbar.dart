import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/utils/color_constants.dart';
import 'package:gym/utils/text_constants.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        TextReplace.appBarTitle,
        style: GoogleFonts.inter(
          color: AppColors.fontColorPrimaryDarkMode,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.backgroundColorDark,
      iconTheme: const IconThemeData(
        color: AppColors.fontColorPrimaryDarkMode,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
