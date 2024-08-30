import 'package:flutter/material.dart';

// Crea un GlobalKey para el Form
final _formKey = GlobalKey<FormState>();

Widget loginScreen() {
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
      padding: const EdgeInsets.all(16.0), // Añade padding alrededor del formulario
      child: Form(
        key: _formKey, // Asocia el GlobalKey con el formulario
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centra los hijos horizontalmente
          children: <Widget>[
            // Primer campo de texto: Correo electrónico
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ingresa tu correo electrónico',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacío';
                }
                // Regex para validar el correo electrónico
                final RegExp emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0), // Añade espacio entre los inputs
            // Segundo campo de texto: Contraseña
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ingresa tu contraseña',
              ),
              obscureText: true, // Hace que el texto se muestre como puntos para proteger la contraseña
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'No puede estar vacío';
                }
                
                return null;
              },
            ),
            const SizedBox(height: 24.0), // Añade espacio antes del botón
            ElevatedButton(
              onPressed: () {
                // Valida el formulario cuando se presiona el botón
                if (_formKey.currentState!.validate()) {
                  // Si el formulario es válido, procesa los datos
                  ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
                    const SnackBar(content: Text('Iniciando sesión')),
                  );
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
