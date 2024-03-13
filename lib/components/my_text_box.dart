import 'package:flutter/material.dart';

import '../utils/color_constants.dart';

class MyTextBox extends StatefulWidget {
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
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  late ThemeData currentTheme;
  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: currentTheme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: currentTheme.hintColor, width: 0.4)),
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
                widget.sectionName,
                style: const TextStyle(
                  color: AppColors.fontColorPrimaryLightMode,
                ),
              ),
              widget.showSettingsIcon
                  ? IconButton(
                      onPressed: widget.onPressed,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.textHintColorDarkMode,
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
            widget.text,
            style: const TextStyle(color: AppColors.fontColorPrimaryDarkMode),
          ),
        ],
      ),
    );
  }
}
