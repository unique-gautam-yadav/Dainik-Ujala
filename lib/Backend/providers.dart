import 'package:flutter/foundation.dart';

import 'package:dainik_ujala/Backend/mytheme_preference.dart';

import 'models.dart';
import 'sqlite_services.dart';

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

class PromotionsProvider with ChangeNotifier {
  List<AdvtModel> _promotions = [];

  void setPromotions(List<AdvtModel> p) {
    _promotions = p;
    notifyListeners();
  }

  AdvtModel? get getPromotionForMainScreen {
    var temp = _promotions.where((element) => element.onMainScreen);
    if (temp.isNotEmpty) {
      SqliteServices().insertAdvt(id: temp.first.id);
      _promotions.remove(temp.first);
      notifyListeners();
      return temp.first;
    } else {
      notifyListeners();
      return null;
    }
  }

  AdvtModel? get getPromotionForDetailScreen {
    var temp = _promotions.where((element) => !element.onMainScreen);
    if (temp.isNotEmpty) {
      SqliteServices().insertAdvt(id: temp.first.id);
      _promotions.remove(temp.first);
      notifyListeners();
      return temp.first;
    } else {
      notifyListeners();
      return null;
    }
  }
}
