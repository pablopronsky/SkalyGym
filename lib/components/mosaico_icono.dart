/// CLASE EN DESUSO MOMENTANEAMENTE, ES PARA REGISTRARSE Y ABRIR SESION CON GOOGLE.
/// NO PUDE HACER QUE SE ASOCIE EL USER_ID DEL GOOGLE SIGN IN CON EL USER_ID DEL OBJETO ALUMNO.
/// NO ES URGENTE SIGO AVANZANDO CON OTRAS COSAS.

import 'package:flutter/material.dart';

class Mosaico extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const Mosaico({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200]),
        child: Image.asset(
          imagePath,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
