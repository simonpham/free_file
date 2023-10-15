import 'dart:ui';

extension ThemeColorExtension on Color {
  Color get withTransparency {
    const enableTransparency = true;
    // final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? 0.6 : 1.0);
  }

  Color applyTransparency([
    double value = 0.6,
  ]) {
    const enableTransparency = true;
    // final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? value : 1.0);
  }

  Color applyTransparencyWith({
    double value = 0.6,
    double base = 1.0,
  }) {
    const enableTransparency = true;
    // final enableTransparency = ThemeConfigs().enableTransparency;
    return withOpacity(enableTransparency ? value * base : base);
  }
}
