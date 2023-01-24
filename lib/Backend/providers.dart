import 'package:flutter/foundation.dart';

import 'package:dainik_ujala/Backend/mytheme_preference.dart';

class ThemeProvider with ChangeNotifier {
  late bool _isDark;
  late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  // ignore: non_constant_identifier_names
  ThemeProvider() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }

//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
