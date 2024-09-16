import 'package:flutter/material.dart';
import 'package:sqllite_note_app_flutter/add_note.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';
import 'package:sqllite_note_app_flutter/model/notes_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() {
    setState(() {
      notesList = dbHelper.getNotesList();
    });
  }


  void editNote(NotesModel note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(noteToEdit: note),
      ),
    );
    if (result == true) {
      refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<List<NotesModel>>(
        future: notesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes yet. Add your first note!"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                NotesModel note = snapshot.data![index];
                return Dismissible(
                  key: Key(note.id.toString()),
                  background:
                  
                  Container(
                     decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.8),
borderRadius: BorderRadius.circular(12)
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    margin: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: 

                   Container(
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.8),
borderRadius: BorderRadius.circular(12)
                    ),
                    alignment: Alignment.centerRight,
                  
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // Delete the notes
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Are you sure you want to delete this note?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("DELETE"),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (direction == DismissDirection.startToEnd) {
                      // Edit
                      editNote(note);
                      return false;
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      dbHelper.deleteNote(note.id!);
                      refreshNotes();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Note deleted")),
                      );
                    }
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        note.descriptions,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(note.date.split(' ')[0]),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
          if (result == true) {
            refreshNotes();
          }
        },
      ),
    );
  }

}