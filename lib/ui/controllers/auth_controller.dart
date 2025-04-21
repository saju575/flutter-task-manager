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
    UserModel userData,
  ) async {
    print("accesToken after login $accesToken");
    await SharedPrefs.setString(_tokenKey, accesToken);
    await SharedPrefs.setString(_userDataKey, jsonEncode(userData.toJson()));

    token = accesToken;
    userModel = userData;
  }

  static Future<void> getUserInformation() async {
    String? accesToken = SharedPrefs.getString(_tokenKey);
    String? savedUserModelString = SharedPrefs.getString(_userDataKey);
    print("token $accesToken");

    if (savedUserModelString != null) {
      UserModel saveUserModel = UserModel.fromJson(
        jsonDecode(savedUserModelString),
      );

      userModel = saveUserModel;
    }
    token = accesToken;
  }

  //Check if user is logged in or not
  static Future<bool> checkIfUserLoggedIn() async {
    String? token = SharedPrefs.getString(_tokenKey);
    print("token after reset $token");
    if (token != null) {
      await getUserInformation();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    await SharedPrefs.clear();
    token = null;
    userModel = null;
  }

  static Future<void> setUserInformation({
    required Map<String, dynamic> newUser,
  }) async {
    Map<String, dynamic> newUserJSON = {...userModel!.toJson(), ...newUser};
    UserModel newUserModel = UserModel.fromJson(newUserJSON);
    await SharedPrefs.setString(
      _userDataKey,
      jsonEncode(newUserModel.toJson()),
    );
    userModel = newUserModel;
  }
}
