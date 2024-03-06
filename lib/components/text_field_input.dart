import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final keyboardType;
  final textInputAction;
  final FocusNode focusNode;
  final bool isPassword;

  const TextFieldInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.autofocus,
    required this.keyboardType,
    this.textInputAction,
    required this.focusNode,
    required this.obscureText,
    required this.isPassword,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          hintText: widget.hintText,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
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
