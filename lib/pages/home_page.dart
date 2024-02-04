import 'package:flutter/material.dart';
import 'package:gym/components/user_name.dart';
import '../components/appbar.dart';
import '../components/calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarComponent(),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          UserName(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: Calendar()),
          //ListaAlumnos(),
        ],
      ),
    );
  }
}
