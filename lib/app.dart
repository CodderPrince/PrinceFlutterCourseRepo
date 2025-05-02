import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager_task/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_task/ui/screens/forget_password_email_verify_screen.dart';
import 'package:task_manager_task/ui/screens/forget_password_otp_verification_screen.dart';
import 'package:task_manager_task/ui/screens/login_screen.dart';
import 'package:task_manager_task/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_task/ui/screens/reset_password_screen.dart';
import 'package:task_manager_task/ui/screens/signup_screen.dart';
import 'package:task_manager_task/ui/screens/splash_screen.dart';
import 'package:task_manager_task/ui/screens/update_profile_screen.dart';

import 'controller_binder.dart';

class TaskManager extends StatelessWidget {
  const TaskManager({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      navigatorKey: TaskManager.navigatorKey,
      title: 'Task Manager',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => SignupScreen(),
        '/resetPassword': (context) => ResetPasswordScreen(),
        '/forgetPasswordEmail': (context) => ForgetPasswordEmailVerifyScreen(),
        '/forgetPasswordPin':
            (context) => ForgetPasswordOtpVerificationScreen(),
        '/MainBottomNavScreen': (context) => MainBottomNavScreen(),
        '/AddNewTaskScreen': (context) => AddNewTaskScreen(),
        '/UpdateProfileScreen': (context) => UpdateProfileScreen(),
      },
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          labelLarge: TextStyle(color: Colors.grey),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: _getZeroBorder(),
          enabledBorder: _getZeroBorder(),
          errorBorder: _getZeroBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.blue,
            iconColor: Colors.white,
            iconSize: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

_getZeroBorder() {
  return const OutlineInputBorder(borderSide: BorderSide.none);
}
