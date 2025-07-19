import 'package:craft_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class SizePicker extends StatefulWidget {
  const SizePicker({super.key, required this.sizes, required this.onSelected});

  final List<String> sizes;
  final Function(String) onSelected;

  @override
  State<SizePicker> createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (String size in widget.sizes)
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = size;
              });
              widget.onSelected(_selected!);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _selected == size ? AppColors.themeColor : null,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      color: _selected == size ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
