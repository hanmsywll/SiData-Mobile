import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'nav.dart';
import 'pages/profile.dart'; // Tambahkan impor ini jika belum ada

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(), // Tambahkan rute login di sini
      },
    );
  }
}
