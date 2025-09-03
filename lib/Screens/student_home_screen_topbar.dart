import 'package:flutter/material.dart';
import 'package:frontend/Screens/student_home_screen.dart';
import 'package:frontend/Screens/updates_screen.dart';

class StudentHomeScreenTopbar extends StatefulWidget {
  final String studentName;
  const StudentHomeScreenTopbar({super.key, required this.studentName});

  @override
  State<StudentHomeScreenTopbar> createState() => _StudentHomeScreenTopbarState();
}

class _StudentHomeScreenTopbarState extends State<StudentHomeScreenTopbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF2B2B2B),
        title: Text("Hi ${widget.studentName}", style: TextStyle(color: Color(0XFFFFFFFF)),),
        centerTitle: true,

        bottom: TabBar(
          indicatorColor: Color(0XFFD4D4D4),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorAnimation: TabIndicatorAnimation.linear,
          indicatorWeight: 4,
          
          labelColor: Colors.blue,
          unselectedLabelColor: Color(0XFFB3B3B3),

          tabs: [
            Tab(text: "For You",),
            Tab(text: "Updates",)
          ],
        ),
      ),
      body: TabBarView(children: [
       StudentHomeScreen(),
       UpdatesScreen(),
      ]),
    ));
  }
}