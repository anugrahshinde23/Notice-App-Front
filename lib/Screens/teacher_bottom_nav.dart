import 'package:flutter/material.dart';
import 'package:frontend/Screens/notice_screen.dart';
import 'package:frontend/Screens/teacher_home_screen.dart';

class TeacherMainScreen extends StatefulWidget {
  
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TeacherHomeScreen( ),
    NoticeScreen(), // Notices
  ];

  //0XFFBAC095 // background color
  //0XFFD4DE95 // text
  //0XFF3D4127 // headings
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF2B2B2B),
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0XFF2B2B2B),
        selectedItemColor: Color(0XFFFFFFFF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Notice'),
        ],
      ),
    );
  }
}
