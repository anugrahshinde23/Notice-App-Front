import 'package:flutter/material.dart';
import 'package:frontend/Screens/login_screen.dart';
import 'package:frontend/Services/api_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String value = 'student';
  final nameController = TextEditingController();
  final passwordContoller = TextEditingController();

  void registerUser() async {
    final data = await ApiServices.register(
      nameController.text,
      value,
      passwordContoller.text,
    );

    if (data.containsKey('user')) {
      print("registered successfully ${data['user']}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      print("failed to register ${data['message']}");
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
                  "Register",
                  style: TextStyle(
                    color: const Color(0XFF2B2B2B),
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
            
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Color(0XFFD4D4D4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: DropdownButton<String>(
                      value: value,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Color(0XFF3D4127)),
                      underline: SizedBox(),
                      dropdownColor: Color(0XFFB3B3B3),
                      onChanged: (String? newValue) {
                        setState(() {
                          value = newValue!;
                        });
                      },
            
                      items: [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text('student'),
                        ),
                        DropdownMenuItem(
                          value: 'teacher',
                          child: Text('teacher'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    registerUser();
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(320, 50)),
                    backgroundColor: WidgetStatePropertyAll(
                      Color(0XFF2B2B2B),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            
                SizedBox(height: 20),
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Color(0XFF2B2B2B)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(320, 50)),
                    backgroundColor: WidgetStatePropertyAll(
                      Color(0XFF2B2B2B),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
