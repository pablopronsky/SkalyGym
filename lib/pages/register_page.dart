// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';
import '../components/snackbar.dart';
import '../model/enum_rol.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers from the registration form
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final celularController = TextEditingController();

  /// Sign up method. Uses Email and Password.
  Future<void> emailSignUp() async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0],
          'name': nombreController.text,
          'lastName': apellidoController.text,
          'phoneNumber': celularController.text,
          'weeklyCredits': 3,
          'role': Role.User.name,
        });
        Navigator.pop(context);
        showCustomSnackBar(
          context: context,
          message: 'Registration Successful!',
          backgroundColor: Colors.green[400],
        );
      } else {
        // Error Snackbar
        showCustomSnackBar(
          context: context,
          message: 'Passwords do not match',
          backgroundColor: Colors.red,
        );
      }
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      showCustomSnackBar(
        context: context,
        message: error.message ?? 'Registration Error',
        backgroundColor: Colors.red[400],
      );
    } catch (error) {
      if (mounted) {
        Navigator.pop(context);
      }
      showCustomSnackBar(
        context: context,
        message: 'An error occurred',
        backgroundColor: Colors.red[400],
      );
    }
  }

  // Error message while logging in
  void showErrorMessage(message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
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
                const SizedBox(height: 25),
                // logo
                Image.asset(
                  'lib/assets/logo_skaly.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 15),
                // Welcome back
                Text(
                  'Crea tu cuenta',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                // Name
                TextFieldInput(
                  controller: nombreController,
                  hintText: 'Nombre',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                // Last name
                TextFieldInput(
                  controller: apellidoController,
                  hintText: 'Apellido',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                // Phone number
                TextFieldInput(
                  controller: celularController,
                  hintText: 'Celular',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                // Email
                TextFieldInput(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                // Password
                TextFieldInput(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                // Repeat password
                TextFieldInput(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 50),
                MyButton(
                  text: 'Registrarme',
                  onTap: emailSignUp,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'O',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ya tenes cuenta? Abri sesión',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Abri sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
