import 'package:flutter/material.dart';

showPopUp(context, message, [bool? isErrorMessage]) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),

      backgroundColor: isErrorMessage == true ? Colors.redAccent : Colors.blue,
      margin: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
