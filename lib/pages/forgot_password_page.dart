import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/textFieldInput.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text
            .trim(), // Trim any leading/trailing whitespace
      );

      // Success message
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                "Si existe el usuario, se ha enviado un email de recuperacion."),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(_handleAuthExceptionMessage(error)),
          );
        },
      );
    }
  }

  // Helper function to handle FirebaseAuthException messages
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Column(
        children: [
          // logo
          Image.asset(
            'lib/assets/logo_skaly.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 25),
          Text(
            'Ingresa el mail para recuperar tu contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 25), // mail
          TextFieldInput(
            controller: _emailController,
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          MaterialButton(
            onPressed: () => passwordResetEmail(),
            child: Text(
              'Recuperar contraseña',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}