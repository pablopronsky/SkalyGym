import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/textFieldInput.dart';

import '../assets/mosaico_icono.dart';

class LoginPage extends StatelessWidget {
   LoginPage ({super.key});

  // controlador para editar texto
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // metodo para abrir sesion
   abrirSesion(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:  SafeArea(
          child: SingleChildScrollView(
          child: Center(
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
                const SizedBox(height: 50),
                //welcome back
                Text('Bienvenido',
                style: TextStyle(color: Colors.grey[700],
                fontSize: 16),
                ),
                const SizedBox(height: 25),

                // usuario
                TextFieldInput(
                  controller:usernameController,
                  hintText: 'Usuario',
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
                  onTap: abrirSesion,
                ),
                const SizedBox(height: 50),

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
                        child:  Text('O abrir sesión con',
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    Mosaico(imagePath: 'lib/assets/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    Mosaico(imagePath: 'lib/assets/apple.png')
                  ],
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
