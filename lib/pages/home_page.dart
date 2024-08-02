import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesonline/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreService fireStoreService = FireStoreService();
  final textController = TextEditingController();
  void updateNote(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
          ),
          title: const Text(
            "Update note",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                fireStoreService.updateNote(id, textController.text);
                textController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  void addNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                fireStoreService.addNote(textController.text);
                textController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => addNote(),
        shape: const CircleBorder(eccentricity: 0),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: ListTile(
                    tileColor: Colors.grey.shade100,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => updateNote(docId),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => fireStoreService.deleteNote(docId),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No data"),
            );
          }
        },
      ),
    );
  }
}
