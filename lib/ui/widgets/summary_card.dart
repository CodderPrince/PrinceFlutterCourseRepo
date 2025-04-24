import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({super.key, required this.title, required this.count});

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text('$title'),
          ],
        ),
      ),
    );
  }
}
