// import 'package:shared_preferences/shared_preferences.dart';

// class TokenStorageService {
//   static const String _tokenKey = 'auth_token';
//   static const String _isLoggedInKey = 'is_logged_in';

//   static Future<void> saveToken(String token, String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//     await prefs.setString('userId', userId);
//     await prefs.setBool(_isLoggedInKey, true);
//   }

//   static Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId');
//   }

//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }

//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isLoggedInKey) ?? false;
//   }

//   static Future<void> clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_tokenKey);
//     await prefs.setBool(_isLoggedInKey, false);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  // دالة لتخزين التوكن و User ID
  static Future<void> saveToken(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString('userId', userId);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // دالة لاسترجاع الـ User ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // دالة لاسترجاع التوكن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // دالة للتحقق إذا كان المستخدم مسجل دخوله
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // دالة لمسح التوكن عند تسجيل الخروج
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
