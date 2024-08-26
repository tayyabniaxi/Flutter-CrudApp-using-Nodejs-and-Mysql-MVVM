import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import your API service
import 'student_form.dart'; // Import the form page

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late Future<List<Map<String, dynamic>>> _students;

  @override
  void initState() {
    super.initState();
    _students = fetchStudents().then((data) => data.cast<Map<String, dynamic>>());
  }

  Future<void> _refreshData() async {
    setState(() {
      _students = fetchStudents().then((data) => data.cast<Map<String, dynamic>>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentForm(
                    name: '',
                    email: '',
                    password: '',
                  ),
                ),
              ).then((_) => _refreshData());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found'));
          }

          final students = snapshot.data!;
          print('Student list: $students'); // Debug print

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text('ID: ${student['ID'] ?? 'No ID'}'),
                subtitle: Text(
                  'Name: ${student['Name'] ?? 'No Name'}\n'
                      'Email: ${student['Email'] ?? 'No Email'}\n'
                      'Password: ${student['Password'] ?? 'No Password'}',
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentForm(
                              studentId: int.tryParse(student['ID']?.toString() ?? '') ?? 0,
                              name: student['Name'] ?? '',
                              email: student['Email'] ?? '',
                              password: student['Password'] ?? '', // Pass the password if needed
                            ),
                          ),
                        ).then((_) => _refreshData());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        // Handle delete on button press
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete'),
                            content: Text('Are you sure you want to delete this student?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final studentId = int.tryParse(student['ID']?.toString() ?? '') ?? 0;
                          if (studentId != 0) {
                            await deleteStudent(studentId);
                            _refreshData();
                          } else {
                            // Handle the case where the ID is not a valid integer
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid student ID')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
