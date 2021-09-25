import 'package:flutter/material.dart';
import 'package:gender_app/screen/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black
      ),
      home: const WelcomeScreen(),
    );
  }
}