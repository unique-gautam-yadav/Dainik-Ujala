import 'package:shared_preferences/shared_preferences.dart';

class MyThemePreferences {
  static const themeKey = "themeKey";
  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(themeKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeKey) ?? true;
  }
}
