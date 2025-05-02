import 'dart:async';
import 'dart:io';
import 'package:task_manager_task/app.dart';
import 'package:task_manager_task/ui/widgets/pop_up_message.dart';

handelException(dynamic error) {
  if (error is SocketException) {
    showPopUp(
      TaskManager.navigatorKey.currentContext,
      'Check internet connection',
    );
  } else if (error is TimeoutException) {
    return "Request timed out. Please try again.";
  } else if (error is FormatException) {
    return "Bad response format. Please contact support.";
  } else {
    return "Something went wrong. Please try again.";
  }
}
