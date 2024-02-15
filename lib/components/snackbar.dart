import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16, // Adjust font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    behavior: behavior,
    backgroundColor: backgroundColor,
    duration: const Duration(milliseconds: 4000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ));
}
