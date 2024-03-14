import 'package:flutter/material.dart';
import 'package:gym/utils/color_constants.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final bool isPassword;

  const TextFieldInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.autofocus,
    required this.keyboardType,
    required this.textInputAction,
    required this.focusNode,
    required this.obscureText,
    required this.isPassword,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _passwordVisible = true;
  late ThemeData currentTheme;
  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: currentTheme.textTheme.labelMedium,
        controller: widget.controller,
        obscureText: widget.isPassword ? _passwordVisible : false,
        autofocus: widget.autofocus,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          enabledBorder:  currentTheme.inputDecorationTheme.enabledBorder,
          focusedBorder: currentTheme.inputDecorationTheme.focusedBorder,
          hintText: widget.hintText,
          fillColor: currentTheme.scaffoldBackgroundColor,
          filled: true,
          hintStyle: currentTheme.textTheme.labelSmall,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: AppColors.textHintColorDarkMode,
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
