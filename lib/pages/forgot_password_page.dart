// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/components/button.dart';
import 'package:gym/utils/color_constants.dart';

import '../components/text_field_input.dart';
import '../utils/text_constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Success message
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                TextReplace.forgotPasswordEmailSent),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              TextReplace.forgotPasswordError, style: GoogleFonts.inter(
              fontSize: 17,
            )
            ),
            content: Text(_handleAuthExceptionMessage(error),
              style: GoogleFonts.inter(
                color: AppColors.backgroundColor,
                fontSize: 15,
              ),
            ),
          );
        },
      );
    }
  }

  String _handleAuthExceptionMessage(FirebaseAuthException error) {
    switch (error.code) {
      case "invalid-email":
        return "Email invalido";
      case "user-not-found":
        return "No hay usuarios registrados con ese mail";
      default:
        return "Ha ocurrido un error: ${error.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const AppBarComponent(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            // logo
            Image.asset('lib/assets/logo_skaly.png',
                width: 150, height: 150, color: AppColors.fontColorPrimary),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                TextReplace.forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.fontColorPrimary,
                ),
              ),
            ),
            const SizedBox(height: 25), // mail
            TextFieldInput(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              focusNode: emailFocusNode,
              isPassword: false,
            ),
            const SizedBox(height: 50),
            MyButton(
              onTap: () => passwordResetEmail(),
              text: TextReplace.forgotPasswordButton,
            ),
          ],
        ),
      ),
    );
  }
}
