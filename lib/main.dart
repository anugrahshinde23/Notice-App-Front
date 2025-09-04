import 'package:flutter/material.dart';
import 'package:frontend/Screens/splash_screen.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Logging
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // // Initialize OneSignal with your App ID
  // OneSignal.initialize("0c5ab1a4-cb63-4475-8897-01b7d9452b1a");

  // // Prompt for push notifications
  // OneSignal.Notifications.requestPermission(true);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: SplashScreen(),
    );
  }
}
