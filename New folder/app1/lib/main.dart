import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // Set the AppBar color for light mode
          titleTextStyle: TextStyle(
            color: Colors.white, // Title text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Set the AppBar color for dark mode
          titleTextStyle: TextStyle(
            color: Colors.white, // Title text color for dark mode
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode:
          ThemeMode.system, // Automatically switch between light and dark

      color: Colors.amber,
      debugShowCheckedModeBanner: false,
      home: const HomeActivity(),
    );
  }
}

class HomeActivity extends StatelessWidget {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic AppBar"), // Title for the AppBar
      ),
      body: const Center(
        child: Text(
          "PRINCE is my Name, hi hello!",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
