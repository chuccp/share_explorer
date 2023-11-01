
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class LocalStore{

 static Future<bool> saveToken({required String token}) async {
    final SharedPreferences prefs = await _prefs;
   return prefs.setString("_token_", token);
  }

 static Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("_token_");
  }

}

