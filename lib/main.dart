import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
// Import file login_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      home: LoginPage(), // Menjadikan LoginPage sebagai halaman utama
    );
  }
}
