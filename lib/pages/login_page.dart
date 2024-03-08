import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';
import 'package:gym/pages/register_page.dart';
import 'package:gym/pages/view_model/login_controller.dart';
import 'package:gym/pages/view_model/login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/constants.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final buttonFocusNode = FocusNode();

  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();

    // Dispose focus nodes
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  width: 170,
                  height: 170,
                  color: Colors.white,
                ),
                const SizedBox(height: 25),
                //welcome back
                const Text(
                  'Accede a tu cuenta Skaly',
                  style: TextStyle(color: AppColors.fontColor, fontSize: 24),
                ),
                const SizedBox(height: 25),
                // mail
                TextFieldInput(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                // contraseña
                TextFieldInput(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  autofocus: false,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Recuperar contraseña',
                          style: TextStyle(
                              color: AppColors.fontLinkColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // boton de abrir sesion
                MyButton(
                    text: 'Abrir sesion',
                    onTap: () => ref
                        .read(loginControllerProvider.notifier)
                        .login(emailController.text, passwordController.text)),
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
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No tenes cuenta?',
                      style: TextStyle(color: AppColors.fontColor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      ),
                      child: const Text(
                        'Registrate',
                        style: TextStyle(
                          color: AppColors.fontLinkColor,
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
