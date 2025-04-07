import 'dart:convert';

import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/shared_prefs.dart';

class AuthController {
  static const String _tokenKey = "token";
  static const String _userDataKey = "user-data";

  static String? token;
  static UserModel? userModel;

  static Future<void> saveUserInformation(
    String accesToken,
    UserModel userModel,
  ) async {
    await SharedPrefs.setString(_tokenKey, accesToken);
    await SharedPrefs.setString(_userDataKey, jsonEncode(userModel.toJson()));

    token = accesToken;
    userModel = userModel;
  }

  static Future<void> getUserInformation() async {
    String? accesToken = SharedPrefs.getString(_tokenKey);
    String? savedUserModelString = SharedPrefs.getString(_userDataKey);

    if (savedUserModelString != null) {
      UserModel saveUserModel = UserModel.fromJson(
        jsonDecode(savedUserModelString),
      );

      userModel = saveUserModel;
    }
    token = accesToken;
  }
}
