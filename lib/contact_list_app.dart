import 'package:flutter/material.dart';
import 'contact_list_screen.dart';

class ContactListApp extends StatelessWidget {
  const ContactListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact List',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF858E98),
        ),
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}