import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: const Color.fromARGB(255, 52, 52, 52),
    secondary: const Color.fromARGB(255, 61, 60, 60),
    inversePrimary: Colors.grey.shade300,
  ),
);
