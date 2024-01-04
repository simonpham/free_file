part of 'theme_configs.dart';

@immutable
class ThemeColor {
  final Color secondary;
  final Color background;
  final Color navBarBackground;
  final Color mainBackground;
  final Color statusBarBackground;
  final Color onBackground;
  final Color iconColor;
  final Color disabledIconColor;

  Color get primary => SystemTheme.accentColor.accent;

  ThemeColor({
    required Color primary,
    required this.secondary,
    required this.background,
    required this.navBarBackground,
    required this.mainBackground,
    required this.statusBarBackground,
    required this.onBackground,
    required this.iconColor,
    required this.disabledIconColor,
  }) {
    SystemTheme.fallbackColor = primary;
  }

  factory ThemeColor.fromJson(Map<String, dynamic> json) {
    return ThemeColor(
      primary: '${json['primary']}'.toColor(),
      secondary: '${json['secondary']}'.toColor(),
      background: '${json['background']}'.toColor(),
      navBarBackground: '${json['navBarBackground']}'.toColor(),
      mainBackground: '${json['mainBackground']}'.toColor(),
      statusBarBackground: '${json['statusBarBackground']}'.toColor(),
      onBackground: '${json['onBackground']}'.toColor(),
      iconColor: '${json['iconColor']}'.toColor(),
      disabledIconColor: '${json['disabledIconColor']}'.toColor(),
    );
  }
}

extension on String {
  Color toColor() {
    final hexCode = replaceAll('#', '');
    if (hexCode.length == 8) {
      return Color(int.parse(hexCode, radix: 16));
    }
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
