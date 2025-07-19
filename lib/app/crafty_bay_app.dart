import 'package:craft_bay/app/app_routes.dart';
import 'package:craft_bay/app/app_theme_data.dart';
import 'package:craft_bay/controller_binder.dart';
import 'package:craft_bay/features/auth/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CraftyBayApp extends StatefulWidget {
  const CraftyBayApp({super.key});

  @override
  State<CraftyBayApp> createState() => _CraftyBayAppState();
}

class _CraftyBayAppState extends State<CraftyBayApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.name,
      theme: AppThemeData.lightThemeData,
      onGenerateRoute: AppRoutes.getRoutes,
    );
  }
}
