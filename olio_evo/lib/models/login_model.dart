import 'package:dio/dio.dart';

import '../api_service.dart';

class LoginResponseModel {
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginResponseModel(
      {this.success, this.statusCode, this.code, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = null;
    message = "Autenticated";
    data = json['data'].length > 0 ? Data.fromJson(json['data']) : null;
  }

  LoginResponseModel.fromJsonSharedService(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = null;
    message = "Autenticated";
    data = json['data']!= null && json['data'].length > 0
        ? Data.fromJsonSharedService(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;

  String email;
  String nicename;
  String displayName;

  Data(this.token, this.email, this.displayName);

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['user_email'];
    nicename = json['user_nicename'];
    displayName = json['user_display_name'];
  }

  Data.fromJsonSharedService(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
    nicename = json['nicename'];
    displayName = json['dispalyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['token'] = token;
    data['user_email'] = email;
    data['user_nicename'] = nicename;
    data['user_display_name'] = displayName;

    return data;
  }
}

class Credentials {
  String username;
  String password;

  Credentials(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['username'] = username;
    data['password'] = password;

    return data;
  }
}
