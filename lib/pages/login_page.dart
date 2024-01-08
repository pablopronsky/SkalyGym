// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/textFieldInput.dart';
import 'package:gym/services/auth_service.dart';
import '../assets/mosaico_icono.dart';

class LoginPage extends StatefulWidget {

  final Function()? onTap;
  const LoginPage ({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controlador para editar texto
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // metodo para abrir sesion
   abrirSesion() async {

     // barrita de cargando
     showDialog(context: context, builder: (context){
       return const Center(
         child: CircularProgressIndicator(),
       );
     },
     );

     // logea sesion
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
            // cierra barrita de cargando
        Navigator.pop(context);
      }on FirebaseAuthException catch (loginErrorMessage){
         Navigator.pop(context);
        showErrorMessage(loginErrorMessage.message);
      }
   }

  // mensajes de error al logear
  void showErrorMessage(message){
    showDialog(
      context: context,
      builder: (context){
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
        body:  SafeArea(
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
                  Text('Bienvenido',
                  style: TextStyle(color: Colors.grey[700],
                  fontSize: 16),
                  ),
                  const SizedBox(height: 25),
      
                  // usuario
                  TextFieldInput(
                    controller:emailController,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Recuperar contraseña',
                        style: TextStyle(color: Colors.grey[600]),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
      
                  // boton de abrir sesion
                  MyButton(
                    text:'Abrir sesion',
                    onTap: abrirSesion,
                  ),
                  const SizedBox(height: 25),
      
                  // o loguear con
                  Padding(
                    padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child:  Text('O',
                          style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                          )
                        )
                      ],
                    ),
                  ),
      
                    const SizedBox(height: 25),
      
      
                  // google + apple sign in buttons
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      Mosaico(
                        onTap: ()=> AuthService().signInWithGoogle(),
                        imagePath: 'lib/assets/google.png',),
                      SizedBox(width: 25),
                      // apple button
                      Mosaico(
                        onTap: ()=> AuthService().signInWithGoogle(),
                        imagePath: 'lib/assets/apple.png',)
                    ],
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
