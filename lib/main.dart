import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';

import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBBFU0fHeVYH_Rd3WlhgXY_T1VUwIPvXRQ",
          appId: "1:793718503034:android:9777b69ae6376ac15fadc3", // Example: "1:793718503034:web:abcd..."
          messagingSenderId: "793718503034",
          projectId: "student-management-syste-82db4",
          storageBucket: "student-management-syste-82db4.firebasestorage.app",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}
