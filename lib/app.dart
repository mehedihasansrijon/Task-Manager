import 'package:flutter/material.dart';
import 'screens/on_boarding/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.green),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// TODO: Implement appbar click to update information page navigate
// -- Note
// Fix this appbar click for next time
// TODO: Edit button click to show alert dialog and edit field