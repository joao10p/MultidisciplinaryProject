import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/login_model.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("login_details") != "" ? true : false;
  }

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("login_details"));
    return prefs.getString("login_details") != "" && prefs.getString("login_details") != null
        ? LoginResponseModel.fromJsonSharedService(
            jsonDecode(prefs.getString("login_details")))
        : null;
  }

  static Future<void> setLoginDetails(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString("login_details",
        loginResponse != null ? jsonEncode(loginResponse.toJson()) : "");
  }

  static Future<void> logout() async {
    await setLoginDetails(null);

  }
}
