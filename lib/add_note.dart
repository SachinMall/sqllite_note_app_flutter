import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';
import 'package:sqllite_note_app_flutter/model/notes_model.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();




  void _saveNote() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    
    if (title.isNotEmpty && description.isNotEmpty) {
      final note = NotesModel(
        title: title,
        descriptions: description,
        date: DateTime.now().toString(),
        timeago: DateTime.now().millisecondsSinceEpoch,
      );

      try {
        final int result = await _dbHelper.insert(note);
        if (result != 0) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to insert note');
        }
      } catch (e) {
        log("$e");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving note: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both title and description")),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text("Save Note"),
            ),
          ],
        ),
      ),
    );
  }


}