import 'package:flutter/material.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';
import 'package:sqllite_note_app_flutter/model/notes_model.dart';

   class DatabaseViewerScreen extends StatelessWidget {
     final DBHelper dbHelper = DBHelper();

  DatabaseViewerScreen({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: const Text('Database Viewer')),
         body: FutureBuilder<List<NotesModel>>(
           future: dbHelper.getNotesList(),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator());
             } else if (snapshot.hasError) {
               return Center(child: Text('Error: ${snapshot.error}'));
             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
               return const Center(child: Text('No data available'));
             } else {
               return ListView.builder(
                 itemCount: snapshot.data!.length,
                 itemBuilder: (context, index) {
                   final note = snapshot.data![index];
                   return ListTile(
                     title: Text(note.title),
                     subtitle: Text(note.descriptions),
                     trailing: Text(note.date),
                   );
                 },
               );
             }
           },
         ),
       );
     }
   }