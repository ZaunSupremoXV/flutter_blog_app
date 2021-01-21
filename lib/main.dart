import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/Authentication.dart';
import 'package:flutter_blog_app/models/Mapping.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize("ca-app-pub-1577485202493071~9154466604");
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
