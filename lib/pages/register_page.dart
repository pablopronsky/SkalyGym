// ignore_for_file: unused_import

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
  late ThemeData currentTheme;

  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconTheme(
                          data: currentTheme.iconTheme,
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 45,
                          ),
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
                  color: currentTheme.brightness == Brightness.dark
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
                Text(
                  TextReplace.registerTitle,
                  style: currentTheme.textTheme.titleLarge,
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
                        Text(
                          TextReplace.registerLoginPageFirst,
                          style: currentTheme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          ),
                          child: Text(
                            TextReplace.registerLoginPageSecond,
                            style: currentTheme.textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
