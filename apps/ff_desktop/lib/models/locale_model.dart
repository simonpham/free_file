import 'package:flutter/material.dart';
import 'package:storage/storage.dart';

class LocaleModel extends ChangeNotifier {
  Locale? get locale {
    final locale = Settings().locale;
    if (locale == null) {
      return null;
    }
    return Locale(locale);
  }

  set locale(Locale? value) {
    Settings().locale = value?.languageCode;
    notifyListeners();
  }
}
