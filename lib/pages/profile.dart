import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/components/my_text_box.dart';
import 'package:gym/utils/constants.dart';

import '../components/snackbar.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppColors.backgroundColor,
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
                  hintStyle: const TextStyle(color: AppColors.fontColor),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.fontColor),
                  ),
                ),
                onChanged: (value) {
                  newValue = value;
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancelar
                    TextButton(
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: AppColors.fontColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Guardar
                    TextButton(
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: AppColors.fontColor),
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
              backgroundColor: AppColors.successColor);
        }).catchError((error) {
          // Error
          showCustomSnackBar(
            context: context,
            message: 'Error al actualizar $field',
            backgroundColor: AppColors.errorColor,
          );
        });
      } else {
        if (value != null) {
          showCustomSnackBar(
            context: context,
            message: 'Edición de $field cancelada',
            backgroundColor: Colors.grey[700],
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const AppBarComponent(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
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
                    // Person Icon
                    const Icon(
                      Icons.person,
                      size: 72,
                        color: AppColors.fontColor,
                    ),
                    // Email
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.fontColor,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Mis Detalles',
                        style: TextStyle(
                          color: AppColors.fontColor,
                        ),
                      ),
                    ),
                    // Name
                    MyTextBox(
                      text: userData['name'],
                      sectionName: 'Nombre',
                      onPressed: () => editField('nombre'),
                      showSettingsIcon: false,
                    ),
                    // Last Name
                    MyTextBox(
                      text: userData['lastName'],
                      sectionName: 'Apellido',
                      onPressed: () => editField('apellido'),
                      showSettingsIcon: false,
                    ),
                    // Email
                    MyTextBox(
                      text: userData['phoneNumber'],
                      sectionName: 'Celular',
                      onPressed: () => editField('celular'),
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
