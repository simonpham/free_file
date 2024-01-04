import 'package:flutter/material.dart';
import 'package:storage/storage.dart';

extension ThemeSettings on Settings {
  bool get enableTransparency =>
      sharedPrefs.getBool(keySettingsEnableTransparency) ?? true;

  set enableTransparency(bool value) {
    sharedPrefs.setBool(keySettingsEnableTransparency, value);
  }

  ThemeMode get themeMode {
    final index =
        sharedPrefs.getInt(keySettingsThemeMode) ?? ThemeMode.light.index;
    return ThemeMode.values[index];
  }

  set themeMode(ThemeMode value) {
    sharedPrefs.setInt(keySettingsThemeMode, value.index);
  }

  List<Uri> get sideBarFavorites {
    final list = sharedPrefs.getStringList(keySettingsSideBarFavorites);
    return list?.map((e) => Uri.parse(e)).toList() ?? [];
  }

  set sideBarFavorites(List<Uri> value) {
    sharedPrefs.setStringList(
      keySettingsSideBarFavorites,
      value.map((e) => e.toString()).toList(),
    );
  }
}

class Settings {
  late final SharedPreferences _sharedPrefs;

  @protected
  SharedPreferences get sharedPrefs => _sharedPrefs;

  static final Settings _instance = Settings._internal();

  factory Settings() => _instance;

  Settings._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<void> reload() {
    return sharedPrefs.reload();
  }
}
