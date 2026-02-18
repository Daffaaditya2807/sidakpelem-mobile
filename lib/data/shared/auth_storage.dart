import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class AuthStorage {
  static const _keyUser = 'auth_user';
  static const _keyLoggedIn = 'auth_logged_in';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, user.toJsonString());
    await prefs.setBool(_keyLoggedIn, true);
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw == null || raw.isEmpty) return null;
    return UserModel.fromJsonString(raw);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.setBool(_keyLoggedIn, false);
  }
}
