import 'package:flutter/material.dart';
import 'package:habitapp/theme/dark_mode.dart';
import 'package:habitapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
