import 'package:flutter/material.dart';
import 'package:habitapp/theme/dark_mode.dart';
import 'package:habitapp/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //intially, dark mode
  ThemeData _themeData = darkMode;

  //get current theme

  ThemeData get themeData => _themeData;

  //is current theme light mode
  bool get isLightMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
