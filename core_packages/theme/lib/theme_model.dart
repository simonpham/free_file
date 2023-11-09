import 'package:flutter/material.dart';
import 'package:storage/data/data.dart';
import 'package:theme/theme.dart';

class ThemeModel extends ChangeNotifier {
  bool get enableTransparency => Settings().enableTransparency;

  set enableTransparency(bool value) {
    Settings().enableTransparency = value;
    notifyListeners();
  }

  ThemeMode get themeMode => Settings().themeMode;

  set themeMode(ThemeMode value) {
    Settings().themeMode = value;
    notifyListeners();
  }

  bool get isDark => themeMode == ThemeMode.dark;

  ScreenSize _screenSize = ScreenSize.normal;

  ScreenSize get screenSize => _screenSize;

  set screenSize(ScreenSize value) {
    _screenSize = value;
    notifyListeners();
  }
}
