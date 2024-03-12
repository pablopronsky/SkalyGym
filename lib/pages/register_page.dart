// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';
import 'package:gym/utils/color_constants.dart';
import '../services/auth_service.dart';
import '../utils/text_constants.dart';
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
      backgroundColor: AppColors.backgroundColorDarkMode,
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
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          CupertinoIcons.arrow_left,
                          size: 45,
                          color: AppColors.fontColorPrimaryDarkMode,
                        ),
                      ),
                    ),
                  ],
                ),
                // LOGO
                Image.asset(
                  'lib/assets/logo_skaly.png',
                  width: 170,
                  height: 170,
                  color: AppColors.fontColorPrimaryDarkMode,
                ),
                Text(
                  TextReplace.registerTitle,
                  style: GoogleFonts.lexend(
                    color: AppColors.fontColorPrimaryDarkMode,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 35),
                // Name
                TextFieldInput(
                  controller: nameController,
                  hintText: TextReplace.registerTxtName,
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  focusNode: nameFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(height: 15),
                // Last name
                TextFieldInput(
                  controller: lastnameController,
                  hintText: TextReplace.registerTxtLastName,
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
                  hintText: TextReplace.registerTxtPhoneNumber,
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
                  hintText: TextReplace.registerTxtEmail,
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
                  hintText: TextReplace.registerTxtPassword,
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
                  hintText: TextReplace.registerTxtConfirmPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  focusNode: confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: TextReplace.registerButton,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        ),
                        child: const Text(
                          TextReplace.registerLoginPage,
                          style: TextStyle(
                            color: AppColors.textHintColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.textHintColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
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
