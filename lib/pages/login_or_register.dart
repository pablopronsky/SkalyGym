import 'package:flutter/material.dart';
import 'package:gym/pages/register_page.dart';

import 'login_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  // pagina de login empieza en true
  bool showLoginPage = true;
  // cambia entre login y register segun el estado negativo del boolean
 void togglePages(){
   setState(() {
     showLoginPage = !showLoginPage;
   });
 }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}

