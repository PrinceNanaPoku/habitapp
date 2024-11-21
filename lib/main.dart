import 'package:flutter/material.dart';
import 'package:habitapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'database/habit_database.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(
      providers: [
        //Theme Provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),

        //Habit Provider
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        )
      ],
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
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
