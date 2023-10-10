import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';

extension ScreenSizeBuildContextExtension on BuildContext {
  ScreenSize get screenSize => select((ThemeConfigs _) => _.screenSize);
}
