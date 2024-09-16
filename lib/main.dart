import 'package:flutter/material.dart';
import 'package:sqllite_note_app_flutter/database/database.dart';
import 'package:sqllite_note_app_flutter/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //make sure to call the db here because it should intialise the db to fetch the stored data
  await DBHelper().initDatabase();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}