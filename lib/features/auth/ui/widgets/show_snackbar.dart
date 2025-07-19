import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
  required BuildContext context,
  required String message,
  bool isError = false,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : Colors.purple,
      content: Container(
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
}
