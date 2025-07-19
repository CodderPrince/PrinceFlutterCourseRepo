import 'package:flutter/material.dart';

class BuildIconButton extends StatelessWidget {
  const BuildIconButton({super.key, required this.onTap, required this.icon});

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        radius: 10,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(icon, color: Colors.white, size: 14),
          ),
        ),
      ),
    );
  }
}
