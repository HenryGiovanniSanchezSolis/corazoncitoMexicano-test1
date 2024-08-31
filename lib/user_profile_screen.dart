import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil de Usuario'),
               leading: IconButton(
                 icon: const Icon(Icons.arrow_back),
                 onPressed: () {
                   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                 },
               ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil de Usuario'),
               leading: IconButton(
                 icon: const Icon(Icons.arrow_back),
                 onPressed: () {
                   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                 },
               ),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil de Usuario'),
               leading: IconButton(
                 icon: const Icon(Icons.arrow_back),
                 onPressed: () {
                   Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                 },
               ),
            ),
            body: const Center(
              child: Text('No se encontró la información del usuario.'),
            ),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil de Usuario'),
             leading: IconButton(
               icon: const Icon(Icons.arrow_back),
               onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
               },
             ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre Completo: ${userData['fullName']}'),
                Text('Correo Electrónico: ${userData['email']}'),
                Text('Número de Teléfono: ${userData['phone']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
