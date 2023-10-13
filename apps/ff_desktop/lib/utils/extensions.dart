import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/constants/constants.dart';

extension ScreenSizeBuildContextExtension on BuildContext {
  ScreenSize get screenSize => ThemeConfigs.screenSize;
}

extension StringExtension on String {
  String getUsernameFromHomeFolder() {
    final parts = split(kSlash);
    if (parts.length > 2) {
      return parts[2];
    }
    return '';
  }

  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
}

extension UriExtension on Uri {
  String get lastNonEmptySegment {
    final path = toFilePath().removeSuffix(kSlash);
    final parts = path.split(kSlash);
    return parts.lastOrNull ?? '';
  }
}
