import 'dart:convert';

import 'package:craft_bay/features/common/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String _userDataKey = 'user-data';
  final String _tokenKey = 'user-token';

  UserModel? userModel;
  String? accessToken;

  Future<void> saveUserData({
    required String token,
    required UserModel model,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));
    await sharedPreferences.setString(_tokenKey, token);
    userModel = model;
    accessToken = token;
  }

  Future<void> getUserData() async {
    debugPrint('inside getUserData');
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString(_userDataKey);
    String? tokenData = sharedPreferences.getString(_tokenKey);
    if (userData != null) {
      debugPrint('inside usermodel');
      userModel = UserModel.fromJson(jsonDecode(userData));
      accessToken = tokenData;
    }
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? tokenData = sharedPreferences.getString(_tokenKey);
    if (tokenData != null) {
      await getUserData();
      return true;
    }
    return false;
  }

  Future<void> clearUserData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    accessToken = null;
    userModel = null;
  }
}
