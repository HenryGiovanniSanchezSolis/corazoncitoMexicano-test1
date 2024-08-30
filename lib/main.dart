import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'home_screen.dart';
import 'user_profile_screen.dart';
var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i("Iniciando Aplicación");
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // Define las rutas
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/home': (context) => LoginScreen(),
        //'/profile': (context) => UserProfileScreen(),
      },
    );
  }
}
