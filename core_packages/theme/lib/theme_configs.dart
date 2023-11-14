import 'dart:convert';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

extension ThemeExtension on BuildContext {
  AppTheme get appTheme =>
      select((ThemeModel _) => _.themeMode == ThemeMode.dark)
          ? ThemeConfigs().darkTheme
          : ThemeConfigs().lightTheme;
}

extension ThemeConfigsExtension on ThemeConfigs {
  ThemeData getThemeData(ThemeMode mode) {
    final isDarkTheme = mode == ThemeMode.dark;
    final config = isDarkTheme ? darkTheme : lightTheme;
    final baseTheme = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: config.color.primary,
      secondary: config.color.secondary,
      background: config.color.background,
      onBackground: config.color.onBackground,
      surface: config.color.mainBackground,
      onSurface: config.color.onBackground,
      surfaceVariant: config.color.navBarBackground,
      onSurfaceVariant: config.color.onBackground,
    );
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      primaryColor: config.color.primary,
      scaffoldBackgroundColor: config.color.mainBackground,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: config.color.navBarBackground,
        foregroundColor: config.color.onBackground,
        iconTheme: IconThemeData(
          color: config.color.iconColor,
        ),
      ),
      bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: config.color.navBarBackground,
        selectedItemColor: config.color.primary,
        unselectedItemColor: config.color.onBackground,
      ),
      iconTheme: IconThemeData(
        color: config.color.iconColor,
      ),
      disabledColor: config.color.disabledIconColor,
    );
  }

  Widget contextCardBuilder(
    BuildContext context,
    List<Widget> children,
  ) {
    return TsCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget contextMenuButtonBuilder(
    BuildContext context,
    ContextMenuButtonConfig config, [
    ContextMenuButtonStyle? style,
  ]) {
    return ListItem(
      onTap: config.onPressed,
      leading: config.icon,
      title: Row(
        children: [
          Expanded(
            child: Text(config.label),
          ),
          if (config.shortcutLabel != null)
            Padding(
              padding: EdgeInsets.only(left: Spacing.d48),
              child: Text(
                '${config.shortcutLabel}',
                style: TextStyle(
                  color: context.theme.disabledColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget contextMenuDividerBuilder(BuildContext context) {
    return const Divider();
  }
}

@immutable
class ThemeConfigs {
  final String name;
  final String version;
  final String description;
  final Config config;
  final AppTheme lightTheme;
  final AppTheme darkTheme;

  static ThemeConfigs? _instance;

  factory ThemeConfigs() {
    assert(_instance != null, 'ThemeConfigs is not initialized');
    return _instance!;
  }

  static Future<void> init() async {
    final json = await rootBundle.loadString(
      'assets/themes/default.json',
    );
    _instance = ThemeConfigs.fromJson(jsonDecode(json));
  }

  const ThemeConfigs._({
    required this.name,
    required this.version,
    required this.description,
    required this.config,
    required this.lightTheme,
    required this.darkTheme,
  });

  factory ThemeConfigs.fromJson(Map<String, dynamic> json) {
    final theme = json['theme'];
    return ThemeConfigs._(
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      config: Config.fromJson(json['config']),
      lightTheme: AppTheme.fromJson(theme['light']),
      darkTheme: AppTheme.fromJson(theme['dark']),
    );
  }
}

@immutable
class Config {
  final bool showBackButton;
  final bool showForwardButton;
  final bool showUpButton;
  final bool showRefreshButton;
  final bool showSearchBar;
  final bool showFileInSideBar;

  const Config({
    required this.showBackButton,
    required this.showForwardButton,
    required this.showUpButton,
    required this.showRefreshButton,
    required this.showSearchBar,
    required this.showFileInSideBar,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      showBackButton: json['showBackButton'] != false,
      showForwardButton: json['showForwardButton'] != false,
      showUpButton: json['showUpButton'] != false,
      showRefreshButton: json['showRefreshButton'] == true,
      showSearchBar: json['showSearchBar'] != false,
      showFileInSideBar: json['showFileInSideBar'] == true,
    );
  }
}

@immutable
class AppTheme {
  final ThemeColor color;

  const AppTheme({
    required this.color,
  });

  factory AppTheme.fromJson(Map<String, dynamic> json) {
    return AppTheme(
      color: ThemeColor.fromJson(json['color']),
    );
  }
}

@immutable
class ThemeColor {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color navBarBackground;
  final Color mainBackground;
  final Color statusBarBackground;
  final Color onBackground;
  final Color iconColor;
  final Color disabledIconColor;

  const ThemeColor({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.navBarBackground,
    required this.mainBackground,
    required this.statusBarBackground,
    required this.onBackground,
    required this.iconColor,
    required this.disabledIconColor,
  });

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
