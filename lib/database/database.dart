import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqllite_note_app_flutter/model/notes_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    try {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, 'notes.db');
      var db = await openDatabase(
        path, 
        version: 1, 
        onCreate: _onCreate,
        onOpen: (db) {
          log("Database opened successfully");
        },
      );
      log("Database initialized successfully");
      return db;
    } catch (e) {
      log("Error initializing database: $e");
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(
        "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, descriptions TEXT NOT NULL, date TEXT NOT NULL, timeago INTEGER NOT NULL)"
      );
      log("Table created successfully");
    } catch (e) {
      log("Error creating table: $e");
      rethrow;
    }
  }

  Future<int> insert(NotesModel notesModel) async {
    try {
      var dbClient = await db;
      int result = await dbClient.insert('notes', notesModel.toMap());
      log("Note inserted successfully: $result");
      return result;
    } catch (e) {
      log("Error inserting note: $e");
      rethrow;
    }
  }

  Future<List<NotesModel>> getNotesList() async {
    try {
      var dbClient = await db;
      final List<Map<String, dynamic>> queryResult = await dbClient.query('notes', orderBy: 'timeago DESC');
      log("Notes retrieved successfully: ${queryResult.length}");
      return queryResult.map((map) => NotesModel.fromMap(map)).toList();
    } catch (e) {
      log("Error retrieving notes: $e");
      rethrow;
    }
  }
}