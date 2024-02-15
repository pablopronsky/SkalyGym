import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/components/my_text_box.dart';

import '../components/snackbar.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  //usuario logeado con firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  // todos los usuarios dentro de la collection 'Users' de firestore
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                textAlign: TextAlign.center,
                "Editar $field",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              content: TextField(
                cursorHeight: 0,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Ingresa nuevo $field",
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey), // Cambia el color aquí
                  ),
                ),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                // Distribuye los botones con espacio entre ellos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancelar
                    TextButton(
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Guardar
                    TextButton(
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.of(context).pop(newValue),
                    ),
                  ],
                ),
              ],
            )).then((value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        newValue = value.toString();
        usersCollection
            .doc(currentUser.email)
            .update({field: newValue}).then((_) {
          // Success
          showCustomSnackBar(
              context: context,
              message: '$field actualizado correctamente',
              backgroundColor: Colors.green[400]);
        }).catchError((error) {
          // Error
          showCustomSnackBar(
            context: context,
            message: 'Error al actualizar $field',
            backgroundColor: Colors.red[400],
          );
        });
      } else {
        if (value != null) {
          // User canceled with value (usually if they pressed back button)
          showCustomSnackBar(
            context: context,
            message: 'Edición de $field cancelada',
            backgroundColor: Colors.grey[700], // Neutral color for canceling
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarComponent(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // foto de perfil
                    const Icon(
                      Icons.person,
                      size: 72,
                    ),
                    // email
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Mis Detalles',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    //Nombre
                    MyTextBox(
                      text: userData['nombre'],
                      sectionName: 'Nombre',
                      onPressed: () => editField('nombre'),
                      showSettingsIcon: false,
                    ),
                    //Apellido
                    MyTextBox(
                      text: userData['apellido'],
                      sectionName: 'Apellido',
                      onPressed: () => editField('apellido'),
                      showSettingsIcon: false,
                    ),
                    //Email
                    MyTextBox(
                      text: userData['celular'],
                      sectionName: 'Celular',
                      onPressed: () => editField('celular'),
                    ),
                    //Cantidad de clases semanales
                    MyTextBox(
                      text: userData['pack de clases'],
                      sectionName: 'Clases semanales',
                      onPressed: () => editField('clases semanales'),
                      showSettingsIcon: false,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
