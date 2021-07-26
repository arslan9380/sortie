import 'package:shared_preferences/shared_preferences.dart';

class PrefServices {
  void saveStringValue(String key, String value) async {
    var _preferences = await SharedPreferences.getInstance();
    _preferences.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.getString(key);
  }

  void saveBoolValue(String key, bool value) async {
    var _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(key, value);
  }

  Future<bool> getBoolValue(String key) async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(key);
  }

  void saveIntValue(String key, int value) async {
    var _preferences = await SharedPreferences.getInstance();
    _preferences.setInt(key, value);
  }

  Future<int> getIntValue(String key) async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.getInt(key);
  }
}
