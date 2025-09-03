import 'package:flutter/material.dart';
import 'package:frontend/Screens/student_home_screen_topBar.dart';
import 'package:frontend/Screens/teacher_bottom_nav.dart';
import 'package:frontend/Screens/register_screen.dart';

import 'package:frontend/Services/api_services.dart';

class LoginScreen extends StatefulWidget {
  final String? collegeId;
  final String? classId;
  const LoginScreen({super.key,  this.collegeId, this.classId});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordContoller = TextEditingController();

  void loginUser() async {
    final data = await ApiServices.login(
      nameController.text,
      passwordContoller.text,
    );

    if (data.containsKey('token')) {
      String role = data['user']['role'];
      print(role);
      if (role == 'teacher') {
        print("successfully login as teacher");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeacherMainScreen()),
        );
      } else if (role == 'student') {
        print("successfully login as student");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
               StudentHomeScreenTopbar(studentName: nameController.text, collegeId: data['user']['college_id'].toString(), classId: data['user']['class_id'].toString()),
          ),
        );
      }
    } else {
      print("login failed ${data['message']} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    color: Color(0XFF2B2B2B),
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 100),

                Container(
                  height: 50,
                  width: 320,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0XFFD4D4D4),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(color: Color(0XFF3D4127)),
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(color: Color(0XFFB3B3B3)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  height: 50,
                  width: 320,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0XFFD4D4D4),
                  ),
                  child: TextField(
                    controller: passwordContoller,
                    style: TextStyle(color: Color(0XFF3D4127)),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Color(0XFFB3B3B3)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),

                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(320, 50)),
                    backgroundColor: WidgetStatePropertyAll(Color(0XFF2B2B2B)),
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Color(0XFF2B2B2B)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen(collegeId: widget.collegeId.toString(), classId: widget.classId.toString())),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(320, 50)),
                    backgroundColor: WidgetStatePropertyAll(Color(0XFF2B2B2B)),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
