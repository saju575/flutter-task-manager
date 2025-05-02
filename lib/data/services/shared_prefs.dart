import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends GetxController {
  final SharedPreferences _prefs;

  SharedPrefs(this._prefs);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);

  Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  Future<bool> remove(String key) async => await _prefs.remove(key);

  Future<bool> clear() async => await _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);
}
