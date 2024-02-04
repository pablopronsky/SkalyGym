import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComponent(),
      body: Column(
        children: [
          Text("Perfil provisorio"),
        ],
      ),
    );
  }
}
