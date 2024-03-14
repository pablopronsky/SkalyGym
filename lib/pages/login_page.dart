import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/text_field_input.dart';
import 'package:gym/pages/register_page.dart';
import 'package:gym/pages/view_model/login_controller.dart';
import 'package:gym/pages/view_model/login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/color_constants.dart';
import '../utils/text_constants.dart';
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
  late ThemeData currentTheme;

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
      currentTheme = Theme.of(context);

      ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'lib/assets/logo_skaly.png',
                  width: 170,
                  height: 170,
                  color: currentTheme.brightness == Brightness.dark ? AppColors.whiteColor : AppColors.blackColor,
                ),
                const SizedBox(height: 15),
                //welcome back
                Text(
                  TextReplace.loginTitle,
                  style: currentTheme.textTheme.titleLarge,
                ),
                const SizedBox(height: 45),
                // mail
                TextFieldInput(
                  controller: emailController,
                  hintText: TextReplace.loginTxtEmail,
                  obscureText: false,
                  autofocus: false,
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
                  hintText: TextReplace.loginTxtPw,
                  obscureText: true,
                  autofocus: false,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ForgotPasswordPage();
                      }));
                    },
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          TextReplace.loginPwRecovery,
                          style: currentTheme.textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // boton de abrir sesion
                MyButton(
                    text: TextReplace.loginButton,
                    onTap: () => ref
                        .read(loginControllerProvider.notifier)
                        .login(emailController.text, passwordController.text)),
                const SizedBox(height: 35),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: AppColors.textHintColorDarkMode,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TextReplace.loginRegisterFirst,
                      style: currentTheme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      ),
                      child: Text(
                        TextReplace.loginRegisterSecond,
                        style: currentTheme.textTheme.displaySmall,
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
