import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({Key? key}) : super(key: key);

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Skaly'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => signOut,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
