import 'dart:convert';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

part 'config.dart';
part 'shortcut.dart';
part 'app_theme.dart';
part 'theme_color.dart';

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
  final Shortcut shortcut;
  final Shortcut workspaceShortcut;
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
    required this.shortcut,
    required this.workspaceShortcut,
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
      shortcut: Shortcut.fromJson(json['shortcut']),
      workspaceShortcut: Shortcut.fromJson(json['workspaceShortcut']),
      lightTheme: AppTheme.fromJson(theme['light']),
      darkTheme: AppTheme.fromJson(theme['dark']),
    );
  }
}
