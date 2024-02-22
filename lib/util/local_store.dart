import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../entry/token.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocalStore {
  static Future<bool> saveToken({required String token, String? code, String? username, Duration? expires}) async {
    final SharedPreferences prefs = await _prefs;
    if (expires != null) {
      DateTime now = DateTime.now();
      DateTime expiresTime = now.add(expires);
      return prefs.setString("_token_", jsonEncode({"expiresTime": expiresTime.microsecondsSinceEpoch, "expires": expires.inSeconds, "code": code, "username": username, "token": token}));
    }
    return prefs.setString("_token_", jsonEncode({"expiresTime": 0, "token": token, "code": code, "username": username}));
  }

  static Future<ExToken?> getToken() async {
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
        saveToken(token: data["token"], code: data["code"], username: data["username"], expires: Duration(seconds: expires));
      }
    }
    return ExToken(token: data["token"], code: data["code"], username: data["username"]);
  }
}
