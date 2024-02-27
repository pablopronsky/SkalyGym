import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym/pages/my_home_page.dart';

import '../providers/auth_provider.dart';

class AuthPage extends ConsumerWidget {
  final Widget targetPage;

  const AuthPage({Key? key, required this.targetPage}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
        data: (user) {
          if (user != null) return const MyHomePage();
          return targetPage;
        },
        loading: () => const SplashScreen(),
        error: (e, trace) => targetPage);
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
