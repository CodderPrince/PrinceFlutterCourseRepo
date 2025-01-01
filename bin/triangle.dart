import 'dart:io';

void triangle() {
  double base, height, area;

  // User input for Base
  stdout.write("Enter the base of the triangle: ");
  try {
    String? baseInput = stdin.readLineSync();
    //base case check for right input
    if (baseInput == null || baseInput.isEmpty) {
      print("Invalid input!");
      return;
    }
    base = double.parse(baseInput);
  } catch (e) {
    print("Invalid input!");
    return;
  }

  //  User input for Height
  stdout.write("Enter the height of the triangle: ");
  try {
    String? heightInput = stdin.readLineSync();
    //base case check for right input
    if (heightInput == null || heightInput.isEmpty) {
      print("Invalid input!");
      return;
    }
    height = double.parse(heightInput);
  } catch (e) {
    print("Invalid input!");
    return;
  }

  // Calculate the area
  area = 0.5 * base * height;

  // Result
  print("The area of the triangle is: ${area.toStringAsFixed(2)}");
}
