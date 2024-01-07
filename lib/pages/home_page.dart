import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final usuario = FirebaseAuth.instance.currentUser!;

  // cerrar sesion
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions:[
        IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
        )
      ]
      ),
      body: Center(child: Text('Bienvenido, ' + usuario.email!,
      style: TextStyle(fontSize: 20),)),
    );
  }
}
