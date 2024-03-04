import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final keyboardType;
  final textInputAction;
  final FocusNode focusNode;

  const TextFieldInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.autofocus,
    required this.keyboardType,
    this.textInputAction,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autofocus: autofocus,
        keyboardType: keyboardType,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          hintText: hintText,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}