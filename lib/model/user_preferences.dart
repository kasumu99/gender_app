import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static final String _kMatricNumber = "matricNumber";
  static final String _fullName = "fullname";
  static final String _lastName = "lastName";
  static Future<String?> getUserMatricNumber() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = await prefs.getString(_kMatricNumber);
    return stringValue;
  }
  static Future<String?> getFullname() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = await prefs.getString(_fullName);
    return stringValue;
  }
  static removeAll() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }
  static Future<bool> setUserMatricNumber(String value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kMatricNumber, value);
  }
  static Future<bool> setFullname(String value) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_fullName, value);
  }
}