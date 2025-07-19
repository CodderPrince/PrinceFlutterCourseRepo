import 'package:craft_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.colors,
    required this.onSelected,
  });

  final List<String> colors;
  final Function(String) onSelected;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (String color in widget.colors)
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = color;
              });
              widget.onSelected(_selected!);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                color: _selected == color ? AppColors.themeColor : null,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  color,
                  style: TextStyle(
                    color: _selected == color ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
