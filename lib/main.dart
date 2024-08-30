import 'package:flutter/material.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:logger/logger.dart';
var logger = Logger();

void main() {
  logger.i("Iniciando Aplicación");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //logger.d("Estamos en el Widget");
    return MaterialApp(
      title: "Corazón Mexicano",
      home: loginScreen()
      /*home: Scaffold(
        body: Center(
          child: Text('Corazoncito Mexicano en proceso...'),
        ),
        
      ),*/
    );
  }
}
