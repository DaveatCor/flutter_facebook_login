import 'package:flutter/material.dart';
import './screen/login_screen.dart';

class App extends StatelessWidget{

  Widget build(context){
    return MaterialApp(
      title: 'Login Me In!',
      home: Scaffold(
        body: LoginScreen(),
        backgroundColor: Colors.blueGrey[800],
      ),
    );
  }
}