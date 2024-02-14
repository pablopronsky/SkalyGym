import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controlador para editar texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // metodo para abrir sesion

  abrirSesion() async {
    // Show loading dialog (await to ensure it displays first)

    // Wrap your asynchronous operations in a Future
    Future(() async {
      try {
        // Sign in with FirebaseAuth
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        // Fetch user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(userCredential.user!.uid)
            .get();
        // Navigate to home page
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home_page');
        }
      } catch (error) {
        // Handle errors gracefully
        if (error is FirebaseAuthException) {
          // Handle FirebaseAuth-specific errors
          showErrorMessage(error.code);
        } else if (error is FirebaseException) {
          // Handle other Firebase-related errors
          showErrorMessage("general-error"); // Show a generic error message
        } else {
          // Handle other errors
          showErrorMessage("general-error"); // Show a generic error message
        }
      }
    }).whenComplete(() {
      // Dismiss the loading dialog when the Future completes
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

// mensajes de error al logear
  void showErrorMessage(String code) {
    String message;
    switch (code) {
      case 'user-not-found':
        message = 'No hay ningún usuario con ese correo electrónico.';
        break;
      case 'wrong-password':
        message = 'La contraseña es incorrecta.';
        break;
      default:
        message = 'Usuario o contraseña incorrectos.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                Image.asset(
                  'lib/assets/logo_skaly.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 25),
                //welcome back
                Text(
                  'Bienvenido',
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
                const SizedBox(height: 25),

                // mail
                TextFieldInput(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // contraseña
                TextFieldInput(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ForgotPasswordPage();
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Recuperar contraseña',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // boton de abrir sesion
                MyButton(
                  text: 'Abrir sesion',
                  onTap: abrirSesion,
                ),
                const SizedBox(height: 25),
                // o loguear con
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No tenes cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Registrate',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
