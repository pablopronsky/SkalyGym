import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              textAlign: TextAlign.center,
              "Editar $field",
              style: currentTheme.textTheme.displayMedium,
            ),
          ),
          content: CupertinoTextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.fillGreyAmbiguousColor,
              ),
              borderRadius: BorderRadius.circular(5),
              color: currentTheme.brightness == Brightness.dark
                  ? const Color.fromRGBO(24, 24, 24, 0.5)
                  : const Color.fromRGBO(215, 217, 214, 1),
            ),
            textAlign: TextAlign.center,
            style: currentTheme.textTheme.labelMedium,
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
                  child: Opacity(
                    opacity: 0.9,
                    child: Text(
                      'Cancelar',
                      style: currentTheme.textTheme.titleSmall,
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
                // Guardar
                TextButton(
                  child: Text(
                    'Guardar',
                    style: currentTheme.textTheme.bodyMedium,
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
