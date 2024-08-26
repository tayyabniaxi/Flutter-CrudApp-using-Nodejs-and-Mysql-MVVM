import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.18.39:8081'; // Replace with your server IP

// Fetch all students
Future<List<Map<String, dynamic>>> fetchStudents() async {
  final response = await http.get(Uri.parse('$baseUrl/students'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => {
      'ID': item['id'],
      'Name': item['name'],
      'Email': item['email'],
      'Password': item['password'],
    }).toList();
  } else {
    throw Exception('Failed to load students');
  }
}

// Add a new student
Future<void> addStudent(String name, String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/students'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception('Failed to add student');
  }
}

// Update an existing student
Future<void> updateStudent(int id, String name, String email, String password) async {
  final response = await http.put(
    Uri.parse('$baseUrl/students/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update student');
  }
}

// Delete a student
Future<void> deleteStudent(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/students/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete student');
  }
}
