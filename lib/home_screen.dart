import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          onPressed: null,
          icon: Icon(Icons.menu),
          tooltip: 'Menú',
        ),
        title: const Text('Corazón Mexicano'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: const Text('Iniciar sesión'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/registerUser');
                  }
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
