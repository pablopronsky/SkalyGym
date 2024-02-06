import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;

    return AppBar(
      title: const Text('Skaly'),
      centerTitle: true,
      backgroundColor: Colors.grey[200],
      leading: FirebaseAuth.instance.currentUser != null
          ? IconButton(
              onPressed: () => currentRoute == '/profile'
                  ? Navigator.pushNamed(
                      context, '/home_page') // Go to HomePage if on profile
                  : Navigator.pushNamed(context, '/profile'),
              icon: currentRoute == '/profile'
                  ? const Icon(Icons.home_filled) // Home icon on profile
                  : const Icon(Icons.person),
            )
          : null,
      actions: [
        IconButton(
          onPressed: () => FirebaseAuth.instance.signOut(),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
