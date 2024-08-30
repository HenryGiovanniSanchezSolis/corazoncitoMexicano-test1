import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'user_profile_screen.dart';

var logger = Logger();

class LoginScreen extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  
        title: const Text('Corazón Mexicano'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Ingresa tu correo electrónico',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa algo';
                  }
                  final RegExp emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                         logger.d(user);
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Inicio de sesión correcta')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(user: user)
                          ),
                        );
                      }
                      //Navigator.pushNamed(context, '/home');
                    } on FirebaseAuthException catch (e) {
                      logger.d(e);
                      if (e.code == 'invalid-credential') {
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Credenciales inválidas')),
                        );
                      } else if (e.code == 'wrong-password') {
                        logger.d("Contraseña mal");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña incorrecta.')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
