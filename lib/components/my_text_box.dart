import 'package:flutter/material.dart';

import '../utils/color_constants.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  final bool showSettingsIcon;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
    this.showSettingsIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textFieldColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  color: AppColors.fontColorPrimary,
                ),
              ),
              showSettingsIcon
                  ? IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.settings,
                        color: AppColors.fontColorPrimary,
                      ),
                    )
                  : const SizedBox(
                      width: 48,
                      height: 48,
                    ),
            ],
          ),
          // Section details
          Text(
            text,
            style: const TextStyle(color: AppColors.fontColorPrimary),
          ),
        ],
      ),
    );
  }
}
