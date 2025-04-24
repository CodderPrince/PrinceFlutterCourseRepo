import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_task/data/model/user_model.dart';

class AuthController {
  static String? token;
  static UserModel? userInfoModel;
  static Logger _logger = Logger();

  static final String _tokenKey = 'token';
  static final String _userDataKey = 'user-data';

  static Future<void> saveUserInformation(
    String accessToken,
    UserModel userModel,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(_tokenKey, accessToken);
    sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));

    _logger.w('Data Saved');

    token = accessToken;
    userInfoModel = userModel;

    _logger.i("This Is Save Data: $userInfoModel");
  }

  static Future<void> getUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? accessToken = sharedPreferences.getString(_tokenKey);
    String? savedUserModelString = sharedPreferences.getString(_userDataKey);

    if (savedUserModelString != null) {
      UserModel userModel = UserModel.convertJsonToDart(
        jsonDecode(savedUserModelString),
      );
      userInfoModel = userModel;
    }
    token = accessToken;

    if (userInfoModel?.firstName != null) {
      _logger.w('User Got the data successfully');
    }
  }

  static Future<bool> checkIfUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(_tokenKey);
    if (accessToken != null) {
      getUserInformation();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    token = null;
    userInfoModel = null;

    _logger.i('Token: ==> $token & cleared');
    _logger.i('Token: ==> $userInfoModel & cleared');
  }
}
