import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocalStore {
  static Future<bool> saveToken({required String token, Duration? expires}) async {
    final SharedPreferences prefs = await _prefs;
    if (expires != null) {
      DateTime now = DateTime.now();
      DateTime expiresTime = now.add(expires);
      return prefs.setString("_token_", jsonEncode({"expiresTime": expiresTime.microsecondsSinceEpoch, "expires": expires.inSeconds, "token": token}));
    }
    return prefs.setString("_token_", jsonEncode({"expiresTime": 0, "token": token}));
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString("_token_");
    if (token == null) {
      return null;
    }
    Map<String, dynamic> data = jsonDecode(token);
    DateTime now = DateTime.now();
    int expiresTime = data["expiresTime"];
    if (expiresTime > 0) {
      if (now.microsecondsSinceEpoch > expiresTime) {
        return null;
      } else {
        int expires = data["expires"];
        saveToken(token: data["token"], expires: Duration(seconds: expires));
      }
    }
    return data["token"];
  }
}
