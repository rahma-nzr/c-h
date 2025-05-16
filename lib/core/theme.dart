import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins', 
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor:  Color.fromARGB(255, 4, 26, 134),
      centerTitle: true,
      elevation: 0,
    ),
  );
}

