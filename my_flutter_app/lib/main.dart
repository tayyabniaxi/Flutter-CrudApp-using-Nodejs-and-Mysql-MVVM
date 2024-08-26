// main.dart

import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/student_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentList(), // Start with the login page
    );
  }
}
