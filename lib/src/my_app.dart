import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perguntas e Respostas',
      theme: ThemeData(
          // brightness: Brightness.dark,
          ),
      home: const MyHomePage(),
    );
  }
}
