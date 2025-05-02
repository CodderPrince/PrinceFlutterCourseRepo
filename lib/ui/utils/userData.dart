import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveDataForLogIn(Map<String, dynamic>? data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', data!['data']['email']);
  prefs.setString('firstName', data['data']['firstName']);
  prefs.setString('lastName', data['data']['lastName']);
  prefs.setString('mobile', data['data']['mobile']);
  prefs.setString('token', data['token']);
  Logger().e('Data Saved Successfully!');
}

Future getData(String? key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('$key');
}

Future<void> removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<void> saveDataForResetPassword({String? email, String? otp}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('ResetEmail', email ?? '');
  prefs.setString('otp', otp ?? '');
  Logger().e('Data Saved Successfully!');
}

Future getDataForResetPassword(String? key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('$key');
}
