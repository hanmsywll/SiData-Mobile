import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<void> setUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<void> setProfileImage(String profileImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', profileImage);
  }

  static Future<String?> getProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('profile_image');
  }
}
