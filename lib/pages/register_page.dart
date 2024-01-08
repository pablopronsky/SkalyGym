import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/button.dart';
import 'package:gym/components/textFieldInput.dart';
import '../assets/mosaico_icono.dart';

class RegisterPage extends StatefulWidget {

  final Function()? onTap;
  const RegisterPage ({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // controlador para editar texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // método para abrir sesión
  Future<void> registrarse() async {
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

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Cerrar el diálogo después de que la operación se haya completado
        Navigator.pop(context);
      } else {
        showErrorMessage('Las contraseñas no coinciden');
      }
    } on FirebaseAuthException catch (error) {
      showErrorMessage(error.message);
    } catch (error) {
      showErrorMessage('Ocurrió un error');
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
                const SizedBox(height: 25),
                // logo
                Image.asset(
                  'lib/assets/logo_skaly.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 15),
                //welcome back
                Text('Crea tu cuenta',
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
                // contraseña
                TextFieldInput(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                // boton de crear sesion
                MyButton(
                  text:'Registrarme',
                  onTap: registrarse,
                ),
                const SizedBox(height: 25),
                // o registrate con
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
                const SizedBox(height: 25),
                // not a member? register now
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
