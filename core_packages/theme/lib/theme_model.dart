import 'package:flutter/material.dart';
import 'package:storage/data/data.dart';

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
}
