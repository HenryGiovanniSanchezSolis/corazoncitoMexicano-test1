import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Necesario para Firestore

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Crear usuario en Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                       
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Usuario Registrado correctamente')));
                         
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: user,
                        );
                      }

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'fullName': _fullNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });

        // Redirige a otra pantalla o muestra un mensaje de éxito
        Navigator.pop(context); // Vuelve a la pantalla anterior (HomeScreen)
      } on FirebaseAuthException catch (e) {
        // Maneja los errores de Firebase Authentication aquí
        String message;
        if (e.code == 'weak-password') {
          message = 'La contraseña es demasiado débil.';
        } else if (e.code == 'email-already-in-use') {
          message = 'El correo electrónico ya está en uso.';
        } else if (e.code == 'invalid-email') {
          message = 'El correo electrónico no es válido.';
        } else {
          message = 'Ha ocurrido un error. Inténtalo de nuevo.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Añadido para evitar overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Nombre Completo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre completo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Número de Teléfono'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu número de teléfono';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
