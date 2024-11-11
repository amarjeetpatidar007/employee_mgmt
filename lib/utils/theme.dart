import 'package:flutter/material.dart';

class AppTheme {
  static MaterialColor iconColor = Colors.blue;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.blue,
    iconTheme: IconThemeData(
        color: iconColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: iconColor,
      suffixIconColor: iconColor
    ),


    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue,
        shadowColor: Colors.blue,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Bu
      ),
    ),
  );
}
