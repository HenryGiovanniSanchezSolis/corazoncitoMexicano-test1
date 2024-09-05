import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';


var logger = Logger();

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
        logger.i(userData);

        var userRole = userData['userRole'];

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Padding(
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

              Center(
              child:
              userRole == 'admin' 
                ? AdminProfileWidget()  // Muestra un widget si es admin
                : UserProfileWidget(),  // Muestra otro widget si es usuario normal
            ),

            ],

          ) 
            /*Center(
              child:
              userRole == 'admin' 
                ? AdminProfileWidget()  // Muestra un widget si es admin
                : UserProfileWidget(),  // Muestra otro widget si es usuario normal
            ),*/
          
          /*body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre Completo: ${userData['fullName']}'),
                Text('Correo Electrónico: ${userData['email']}'),
                Text('Número de Teléfono: ${userData['phone']}'),
              ],
            ),
          ),*/
        );
      },
    );
  }
}

// Definimos widgets condicionales según el rol
class AdminProfileWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        const Text('¡Bienvenido, Administrador!'),
        ElevatedButton(
          onPressed: () {
            // Funcionalidad especial para el admin
          },
          child:
          
           const Text('Agregar tareas'),
        ),
        
        
      ],
    );
  }
}

class UserProfileWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¡Bienvenido Alumn@!'),
        ElevatedButton(
          onPressed: () {
            // Funcionalidad para usuario estándar
          },
          child: const Text('Buscar tareas'),
        ),
      ],
    );
  }
}
