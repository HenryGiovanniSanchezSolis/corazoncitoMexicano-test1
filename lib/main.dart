import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
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
      title: 'Corazón Mexicano Demo',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/registerUser':
            return MaterialPageRoute(builder: (context) => const RegisterScreen());
          case '/profile':
            final user = settings.arguments as User;
            return MaterialPageRoute(
              builder: (context) => UserProfileScreen(user: user),
            );
          default:
            return MaterialPageRoute(builder: (context) => HomeScreen());
        }
      },
    );
  }
}
