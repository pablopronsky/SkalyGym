import 'package:flutter/material.dart';
import 'package:gym/utils/constants.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
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
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: widget.hintText,
          fillColor: AppColors.textFieldColor,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: Colors.grey,
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
