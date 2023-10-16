import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/constants/constants.dart';

extension ScreenSizeBuildContextExtension on BuildContext {
  ScreenSize get screenSize => ThemeConfigs.screenSize;
}
