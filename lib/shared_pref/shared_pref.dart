import 'dart:convert';

import 'package:make_my_zen/model/healing_modality_model.dart';
import 'package:make_my_zen/model/login_response_model.dart';
import 'package:make_my_zen/model/meditation_combo_model.dart';
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

  // ================== HOME SCREEN CACHE ==================

  static const String _comboCacheKey = "cached_meditation_combos";
  static const String _healingCacheKey = "cached_healing_modalities";

  static Future<void> saveCachedCombos(
    List<MeditationComboModel> combos,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = combos.map((e) => e.toJson()).toList();
    await prefs.setString(_comboCacheKey, jsonEncode(jsonList));
  }

  static Future<List<MeditationComboModel>?> getCachedCombos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_comboCacheKey);
    if (data == null) return null;

    final List decoded = jsonDecode(data);
    return decoded.map((e) => MeditationComboModel.fromJson(e)).toList();
  }

  static Future<void> saveCachedHealingModalities(
    List<HealingModalityModel> list,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((e) => e.toJson()).toList();
    await prefs.setString(_healingCacheKey, jsonEncode(jsonList));
  }

  static Future<List<HealingModalityModel>?>
  getCachedHealingModalities() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_healingCacheKey);
    if (data == null) return null;

    final List decoded = jsonDecode(data);
    return decoded.map((e) => HealingModalityModel.fromJson(e)).toList();
  }
}
