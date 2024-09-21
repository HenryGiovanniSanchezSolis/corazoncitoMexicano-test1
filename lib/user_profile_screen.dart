import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'interface/task.dart';

var logger = Logger();

class UserProfileScreen extends StatelessWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bienvenido'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
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
              title: const Text('Bienvenido'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
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
              title: const Text('Bienvenido'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
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
              title: const Text('Bienvenido'),
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context)
                          .openDrawer(); // Abre la barra lateral
                    },
                  );
                },
              ),
            ),
            drawer: Drawer(
              // Aquí defines el contenido de la barra lateral
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //const Text('Información del Perfil'),
                    Text('Nombre Completo: ${userData['fullName']}'),
                    Text('Correo Electrónico: ${userData['email']}'),
                    Text('Número de Teléfono: ${userData['phone']}'),
                    const Divider(),
                    ListTile(
                      title: const Text('Cerrar sesión'),
                      onTap: () {
                        // Aquí puedes manejar el cierre de sesión
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Padding(
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
                Center(
                  child: userRole == 'admin'
                      ? AdminProfileWidget() // Muestra un widget si es admin
                      : UserProfileWidget(), // Muestra otro widget si es usuario normal
                ),
              ],
            ));
      },
    );
  }
}

class AdminProfileWidget extends StatefulWidget {
  const AdminProfileWidget({Key? key}) : super(key: key);

  @override
  _AdminProfileWidgetState createState() => _AdminProfileWidgetState();
}

class _AdminProfileWidgetState extends State<AdminProfileWidget> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final thumbnailController = TextEditingController();

  void _addTask() async {
    final newTask = {
      'title': titleController.text,
      'description': descriptionController.text,
      'thumbnail': thumbnailController.text,
    };
    await FirebaseFirestore.instance.collection('tasks').add(newTask);
    titleController.clear();
    descriptionController.clear();
    thumbnailController.clear();
  }

  void _deleteTask(String id) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id).delete();
  }

  void _editTask(String id) async {
    final updatedTask = {
      'title': titleController.text,
      'description': descriptionController.text,
      'thumbnail': thumbnailController.text,
    };
    await FirebaseFirestore.instance.collection('tasks').doc(id).update(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Añadido para permitir el desplazamiento
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextField(
            controller: thumbnailController,
            decoration: const InputDecoration(labelText: 'URL de Miniatura'),
          ),
          ElevatedButton(
            onPressed: _addTask,
            child: const Text('Agregar Tarea'),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                final taskList = snapshot.data!.docs;

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento del ListView
                  shrinkWrap: true, // Hacer que el ListView se ajuste a su contenido
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    final taskData = task.data() as Map<String, dynamic>;
                    final taskId = task.id;

                    return ListTile(
                      title: Text(taskData['title']),
                      subtitle: Text(taskData['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              titleController.text = taskData['title'];
                              descriptionController.text = taskData['description'];
                              thumbnailController.text = taskData['thumbnail'];
                              _editTask(taskId); // Editar tarea
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(taskId); // Eliminar tarea
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No hay tareas disponibles'));
              }
            },
          ),
        ],
      ),
    );
  }
}




class UserProfileWidget extends StatelessWidget {
  //const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("Mostrando UserProfileWidget");
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data!.docs; // Obtiene los documentos
          return SingleChildScrollView(
            // Envolver en SingleChildScrollView
            child: Column(
              children: [
                // Otros widgets antes del ListView

                // Usar ListView.builder sin Expanded aquí
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Deshabilitar scroll del ListView
                  shrinkWrap:
                      true, // Hacer que el ListView tome solo el espacio necesario
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: task['thumbnail'],
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        title: Text(task['title']),
                        subtitle: Text(task['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.done), onPressed: () {}),
                            IconButton(
                                icon: const Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
