import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notify/Screens/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
     {

  @override
  void initState() {
    super.initState();

 

    // ⏳ 3 sec wait
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(), // 👈 sirf login page call karo
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            ClipOval(
              child: Image.asset('assets/images/bell.gif',
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 20,),
            
            Text(
            "NOTIFY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          ]
        ),
        
      ),
    );
  }
}
