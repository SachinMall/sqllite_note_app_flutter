import 'package:flutter/material.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';
import 'package:sqllite_note_app_flutter/model/notes_model.dart';

class AddNotePage extends StatefulWidget {
  final NotesModel? noteToEdit;

  const AddNotePage({super.key, this.noteToEdit});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.noteToEdit != null) {
      _titleController.text = widget.noteToEdit!.title;
      _descriptionController.text = widget.noteToEdit!.descriptions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteToEdit == null ? "Add Note" : "Edit Note"),
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
           SizedBox(
            width: MediaQuery.of(context).size.width,height: 48,
             child: ElevatedButton(
               onPressed: _saveNote,
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.blueAccent,
                 foregroundColor: Colors.white, 
                 shape: const BeveledRectangleBorder()
               ),
               child: Text(
                 widget.noteToEdit == null ? "Save Note" : "Update Note",
               ),
             ),
           ),

          ],
        ),
      ),
    );
  }

  void _saveNote() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    
    if (title.isNotEmpty && description.isNotEmpty) {
      final note = NotesModel(
        id: widget.noteToEdit?.id,
        title: title,
        descriptions: description,
        date: DateTime.now().toString(),
        timeago: DateTime.now().millisecondsSinceEpoch,
      );

      try {
        if (widget.noteToEdit == null) {
          await _dbHelper.insert(note);
        } else {
          await _dbHelper.updateNote(note);
        }
        Navigator.pop(context, true);
      } catch (e) {
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
}

