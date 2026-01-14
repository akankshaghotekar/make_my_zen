import 'package:make_my_zen/model/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const _keyIsLoggedIn = "is_logged_in";
  static const _keyUserSrNo = "user_srno";
  static const _keyName = "name";
  static const _keyEmail = "email";

  /// SAVE LOGIN
  static Future<void> saveLogin({
    required String userSrNo,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserSrNo, userSrNo);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  /// CHECK LOGIN
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<LoginResponseModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    return LoginResponseModel(
      userSrNo: prefs.getString(_keyUserSrNo) ?? '',
      name: prefs.getString(_keyName) ?? '',
      email: prefs.getString(_keyEmail) ?? '',
      gender: '',
      ageGroup: '',
      language: '',
      country: '',
    );
  }

  static Future<String?> getUserSrNo() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;
    return prefs.getString(_keyUserSrNo);
  }
}
