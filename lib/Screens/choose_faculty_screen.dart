import 'package:flutter/material.dart';
import 'package:frontend/Screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChooseFacultyScreen extends StatefulWidget {
  final String name;
  final String role;
  final String password;
  const ChooseFacultyScreen({
    super.key,
    required this.name,
    required this.role,
    required this.password,
  });

  @override
  State<ChooseFacultyScreen> createState() => _ChooseFacultyScreenState();
}

class _ChooseFacultyScreenState extends State<ChooseFacultyScreen> {
  List colleges = [];
  List classes = [];

  String? selectedCollege;
  String? selectedClass;

  @override
  void initState() {
    super.initState();
    fetchColleges();
  }

  Future<void> fetchColleges() async {
    final response = await http.get(
      Uri.parse("http://192.168.179.124:1000/info/colleges"),
    );
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        colleges = data['colleges'];
      });
    }
  }

  Future<void> fetchClasses(String collegeId) async {
    final response = await http.get(
      Uri.parse("http://192.168.179.124:1000/info/classes/$collegeId"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        classes = data['classes'];
        selectedClass = null; // reset when college changes
      });
    }
  }

  Future<void> completeRegistration() async {
    final response = await http.post(
      Uri.parse('http://192.168.179.124:1000/api/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "name": widget.name,
        "password": widget.password,
        "role": widget.role,
        "college_id": selectedCollege,
        "class_id": selectedClass,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registration successful")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(collegeId: selectedCollege.toString(), classId: selectedClass.toString())),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error in registration")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('select class and college')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              initialValue: selectedCollege,
              hint: Text("Select College"),
              items: colleges.map((college) {
                return DropdownMenuItem(
                  value: college['id'].toString(),
                  child: Text(college['name']),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCollege = value;
                  classes = [];
                  selectedClass = null;
                });
                fetchClasses(value!);
              },
            ),

            SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedClass,
              hint: Text('Select Class'),
              items: classes.map((cls) {
                return DropdownMenuItem(
                  value: cls['id'].toString(),
                  child: Text(cls['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedCollege != null && selectedClass != null
                  ? completeRegistration
                  : null,
              child: Text("Complete Registration"),
            ),
          ],
        ),
      ),
    );
  }
}
