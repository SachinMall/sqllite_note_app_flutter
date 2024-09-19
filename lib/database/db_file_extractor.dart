import 'dart:io';
   import 'package:path_provider/path_provider.dart';
   import 'package:path/path.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';

   class DatabaseFileExtractor {
     static Future<String> getDatabaseFilePath() async {
       final dbHelper = DBHelper();
       final databasePath = await dbHelper.getDatabasePath();
       
       // Get the external storage directory
       final directory = await getExternalStorageDirectory();
       final extractedDbPath = join(directory!.path, 'extracted_notes.db');
       
       // Copy the database file to the new location
       File(databasePath).copy(extractedDbPath);
       
       print('Database extracted to: $extractedDbPath');
       return extractedDbPath;
     }
   }