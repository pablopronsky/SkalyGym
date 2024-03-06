// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers from the registration form
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final nameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final signUpFocusNode = FocusNode();

  AuthService authService = AuthService();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login_page');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
                const SizedBox(height: 25),
                // Name
                TextFieldInput(
                  controller: nameController,
                  hintText: 'Nombre',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  focusNode: nameFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(height: 15),
                // Last name
                TextFieldInput(
                  controller: lastnameController,
                  hintText: 'Apellido',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  focusNode: lastNameFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(height: 15),
                // Phone number
                TextFieldInput(
                  controller: phoneNumberController,
                  hintText: 'Celular',
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  autofocus: false,
                  focusNode: phoneNumberFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(height: 15),
                // Email
                TextFieldInput(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  focusNode: emailFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(height: 15),
                // Password
                TextFieldInput(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: true,
                ),
                const SizedBox(height: 15),
                // Repeat password
                TextFieldInput(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar contraseña',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  focusNode: confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                ),
                const SizedBox(height: 50),
                MyButton(
                  text: 'Registrar',
                  onTap: () async {
                    await authService.emailSignUp(
                        nameController.text,
                        lastnameController.text,
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                        phoneNumberController.text,
                        context);
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
