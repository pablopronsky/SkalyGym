import 'package:flutter/material.dart';

import '../utils/color_constants.dart';

/// Re usable snackBar that takes a context, a color and a String as a message as parameters.
void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    ),
    behavior: behavior,
    backgroundColor: AppColors.accentColor,
    duration: const Duration(milliseconds: 4000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}
