import 'dart:ui';

import 'package:theme/theme.dart';

extension ThemeColorExtension on Color {
  Color get withTransparency {
    final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? 0.6 : 1.0);
  }

  Color applyTransparency([
    double value = 0.6,
  ]) {
    final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? value : 1.0);
  }

  Color applyTransparencyWith({
    double value = 0.6,
    double base = 1.0,
  }) {
    final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? value * base : base);
  }
}
