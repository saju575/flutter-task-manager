import 'dart:convert';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/shared_prefs.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static const String _tokenKey = "token";
  static const String _userDataKey = "user-data";
  final SharedPrefs _sharedPrefs;
  AuthController(this._sharedPrefs);

  String? token;
  UserModel? userModel;

  Future<void> saveUserInformation(
    String accesToken,
    UserModel userData,
  ) async {
    await _sharedPrefs.setString(_tokenKey, accesToken);
    await _sharedPrefs.setString(_userDataKey, jsonEncode(userData.toJson()));

    token = accesToken;
    userModel = userData;
    update();
  }

  Future<void> getUserInformation() async {
    String? accesToken = _sharedPrefs.getString(_tokenKey);
    String? savedUserModelString = _sharedPrefs.getString(_userDataKey);

    if (savedUserModelString != null) {
      UserModel saveUserModel = UserModel.fromJson(
        jsonDecode(savedUserModelString),
      );

      userModel = saveUserModel;
    }
    token = accesToken;
    update();
  }

  //Check if user is logged in or not
  Future<bool> checkIfUserLoggedIn() async {
    String? token = _sharedPrefs.getString(_tokenKey);
    if (token != null) {
      await getUserInformation();
      return true;
    }
    return false;
  }

  Future<void> clearUserData() async {
    await _sharedPrefs.clear();
    token = null;
    userModel = null;
    update();
  }

  Future<void> setUserInformation({
    required Map<String, dynamic> newUser,
  }) async {
    Map<String, dynamic> newUserJSON = {...userModel!.toJson(), ...newUser};
    UserModel newUserModel = UserModel.fromJson(newUserJSON);
    await _sharedPrefs.setString(
      _userDataKey,
      jsonEncode(newUserModel.toJson()),
    );
    userModel = newUserModel;
    update();
  }
}
