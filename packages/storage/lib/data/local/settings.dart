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

  List<Uri> get pinnedUris {
    final list = sharedPrefs.getStringList(keySettingsPinnedUris);
    return list?.map((e) => Uri.parse(e)).toList() ?? [];
  }

  set pinnedUris(List<Uri> value) {
    sharedPrefs.setStringList(
      keySettingsPinnedUris,
      value.map((e) => e.toString()).toList(),
    );
  }

  bool get showHiddenFiles =>
      sharedPrefs.getBool(keySettingsShowHiddenFiles) ?? false;

  set showHiddenFiles(bool value) {
    sharedPrefs.setBool(keySettingsShowHiddenFiles, value);
  }

  String? get locale => sharedPrefs.getString(keySettingsLocale);

  set locale(String? value) {
    if (value == null) {
      sharedPrefs.remove(keySettingsLocale);
      return;
    }
    sharedPrefs.setString(keySettingsLocale, value);
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
