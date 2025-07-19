import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (String? value) {},
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: Colors.grey,
        hintText: 'Search',
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        border: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
