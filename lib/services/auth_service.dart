import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/snackbar.dart';

class AuthService {
  ///Google Sign In method. not being used yet.
  signInWithGoogle() async {
    // Interact
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Auth_details
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    // User credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Log in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Email register, Unimplemented with riverpod YET
  Future<void> emailSignUp(
      String nameController,
      String lastnameController,
      String emailController,
      String passwordController,
      String confirmPasswordController,
      String phoneController,
      context) async {
    try {
      if (!passwordsMatch(passwordController, confirmPasswordController)) {
        showPasswordMismatchError(context);
        return;
      }
      showProgressDialog(context);

      if (await validateEmail(emailController, context)) {
        Navigator.pop(context);
        return;
      }

      final userCredential =
          await createUser(emailController, passwordController);

      await saveUserData(userCredential, emailController, nameController,
          lastnameController, phoneController);

      showRegistrationSuccess(context);
      Navigator.pushReplacementNamed(context, 'auth_check');
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      showFirebaseRegistrationError(error, context);
    } catch (error) {
      Navigator.pop(context);
      showGenericRegistrationError(context);
    }
  }

  bool passwordsMatch(
      String passwordController, String confirmPasswordController) {
    return passwordController == confirmPasswordController;
  }

  Future<bool> validateEmail(String emailController, context) async {
    String emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(emailController) ||
        !EmailValidator.validate(emailController)) {
      showCustomSnackBar(
        context: context,
        message: 'Por favor ingresa un email válido',
        backgroundColor: Colors.red,
      );
      return true;
    }
    return false;
  }

  void showProgressDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<UserCredential> createUser(
      String emailController, String passwordController) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController,
      password: passwordController,
    );
  }

  Future<void> saveUserData(
      UserCredential userCredential,
      String emailController,
      String nameController,
      String lastnameController,
      String phoneNumber) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.email)
        .set({
      'username': emailController.split('@')[0],
      'name': nameController,
      'lastName': lastnameController,
      'phoneNumber': phoneNumber,
      'weeklyCredits': 3,
    });
  }

  void showPasswordMismatchError(context) {
    showCustomSnackBar(
      context: context,
      message: 'Las contraseñas son diferentes',
      backgroundColor: Colors.red,
    );
  }

  void showRegistrationSuccess(context) {
    showCustomSnackBar(
      context: context,
      message: 'Registro exitoso',
      backgroundColor: Colors.green[400],
    );
  }

  void showFirebaseRegistrationError(FirebaseAuthException error, context) {
    String message;
    switch (error.code) {
      case 'email-already-in-use':
        message = 'El email ingresado ya está en uso. Intenta con otro.';
        break;
      case 'weak-password':
        message =
            'La contraseña es demasiado débil. Debe tener al menos 6 caracteres.';
        break;
      default:
        message = 'Error al registrarte. Intentalo nuevamente más tarde.';
    }
    showCustomSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red[400],
    );
  }

  void showGenericRegistrationError(context) {
    showCustomSnackBar(
      context: context,
      message: 'Ocurrió un error',
      backgroundColor: Colors.red[400],
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
