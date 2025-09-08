import 'package:flutter/material.dart';
import 'package:notify/Screens/notice_screen.dart';
import 'package:notify/Screens/teacher_home_screen.dart';

class TeacherMainScreen extends StatefulWidget {
  final String collegeId;
  final String classId;
  final int? teacherId;
  final String? teacherName;

  const TeacherMainScreen({
    super.key,
    required this.collegeId,
    required this.classId,
    this.teacherId,
    this.teacherName,
  });

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
  

    _screens = [
      TeacherHomeScreen(
        collegeId: widget.collegeId,
        classId: widget.classId,
        teacherId: widget.teacherId,
        teacherName: widget.teacherName,
      ),
      NoticeScreen(
        collegeId: widget.collegeId,
        classId: widget.classId,
        teacherId: widget.teacherId,
        teacherName: widget.teacherName,
      ), // Notices
    ];
  }

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
