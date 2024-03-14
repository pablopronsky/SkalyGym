import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/components/appbar.dart';
import 'package:gym/components/my_text_box.dart';
import 'package:gym/utils/color_constants.dart';
import 'package:gym/utils/text_constants.dart';

import '../components/snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  late ThemeData currentTheme;

  @override
  void initState() {
    super.initState();
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogTheme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: dialogTheme.scaffoldBackgroundColor,
          title: Text(
            textAlign: TextAlign.center,
            "Editar $field",
            style: currentTheme.textTheme.titleMedium,
          ),
          content: TextField(
            cursorHeight: 0,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            textAlign: TextAlign.center,
            style:
                dialogTheme.textTheme.labelSmall?.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: "${TextReplace.hintEditDialog}$field",
              hintStyle: TextStyle(
                color: dialogTheme.hintColor,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: AppColors.fontColorPrimaryDarkMode),
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
                    style: TextStyle(
                      color: AppColors.fontColorPrimaryDarkMode,
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                // Guardar
                TextButton(
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: AppColors.fontColorPrimaryDarkMode,
                    ),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(newValue),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        newValue = value.toString();
        usersCollection
            .doc(currentUser.email)
            .update({field: newValue}).then((_) {
          // Success
          showCustomSnackBar(
              context: context,
              message: '$field actualizado.',
              backgroundColor: AppColors.successColor);
        }).catchError((error) {
          // Error
          showCustomSnackBar(
            context: context,
            message: 'Error al actualizar $field.',
            backgroundColor: AppColors.errorColor,
          );
        });
      } else {
        if (value != null) {
          showCustomSnackBar(
            context: context,
            message: 'Edición de $field cancelada.',
            backgroundColor: AppColors.errorColor,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentTheme = Theme.of(context);
    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
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
                    IconTheme(
                      data: currentTheme.iconTheme,
                      child: const Icon(
                        Icons.person,
                        size: 72,
                      ),
                    ),
                    // Email
                    Text(
                      currentUser.email!,
                      textAlign: TextAlign.center,
                      style: currentTheme.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      TextReplace.profileMyDetails,
                      style: currentTheme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Name
                    MyTextBox(
                      text: userData['name'],
                      sectionName: TextReplace.profileName,
                      onPressed: () => {},
                      showSettingsIcon: false,
                    ),
                    // Last Name
                    MyTextBox(
                      text: userData['lastName'],
                      sectionName: TextReplace.profileLastName,
                      onPressed: () => {},
                      showSettingsIcon: false,
                    ),
                    // Email
                    MyTextBox(
                      text: userData['phoneNumber'],
                      sectionName: TextReplace.profilePhoneNumber,
                      onPressed: () => editField('celular'),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error${snapshot.error}',
                    style: currentTheme.textTheme.titleMedium,
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
