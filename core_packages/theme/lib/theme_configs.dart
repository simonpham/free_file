import 'package:core_ui/core_ui.dart';
import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

enum ThemeDataKeys {
  key,
  themeMode,
  enableTransparency,
  screenSize,
}

extension ThemeConfigsExtension on ThemeConfigs {
  ScreenSize get screenSize {
    final index = get(
      ThemeDataKeys.screenSize,
      defaultValue: ScreenSize.normal.index,
    );
    return ScreenSize.values[index];
  }

  set screenSize(ScreenSize value) => put(
        ThemeDataKeys.screenSize,
        value.index,
      );

  bool get enableTransparency => kIsDesktop
      ? get(
          ThemeDataKeys.enableTransparency,
          defaultValue: kIsDesktop,
        )
      : false;

  set enableTransparency(bool value) => put(
        ThemeDataKeys.enableTransparency,
        value,
      );

  ThemeMode get themeMode {
    final index = get(
      ThemeDataKeys.themeMode,
      defaultValue: ThemeMode.system.index,
    );
    return ThemeMode.values[index];
  }

  set themeMode(ThemeMode value) => put(ThemeDataKeys.themeMode, value.index);

  ThemeData getThemeData(ThemeMode themeMode) {
    final isDark = themeMode == ThemeMode.dark;
    final cardColor = enableTransparency
        ? kNeutralSwatch[1]!.applyTransparency(isDark ? 0.05 : 0.9)
        : (isDark ? kNeutralSwatch[6] : kNeutralSwatch[1]);

    final base = isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    final colorSwatch = ColorScheme.fromSwatch(
      primarySwatch: kPrimaryMaterialColor,
    ).copyWith(
      background:
          (isDark ? kBackgroundColorDark : kBackgroundColor).withTransparency,
      onBackground: isDark ? kOnBackgroundColorDark : kOnBackgroundColor,
      surface: cardColor,
      surfaceTint: Colors.transparent,
    );
    return base.copyWith(
      extensions: [
        ...base.extensions.values,
        FlashBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Spacing.d16),
            ),
          ),
          margin: EdgeInsets.all(Spacing.d16),
          backgroundColor: colorSwatch.primary,
          surfaceTintColor: Colors.transparent,
        ),
      ],
      textTheme: base.textTheme.apply(
        fontFamily: kAppFontFamily,
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: kAppFontFamily,
      ),
      primaryColor: colorSwatch.primary,
      scaffoldBackgroundColor: colorSwatch.background,
      cardColor: colorSwatch.surface,
      colorScheme: colorSwatch,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Spacing.d12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? kNeutralSwatch[3]! : kNeutralSwatch[5]!,
            width: Spacing.d1,
          ),
          borderRadius: BorderRadius.circular(Spacing.d12),
        ),
      ),
      dividerColor: isDark ? kNeutralSwatch[5]! : kNeutralSwatch[3]!,
      dividerTheme: DividerThemeData(
        color: isDark ? kNeutralSwatch[5]! : kNeutralSwatch[3]!,
        thickness: Spacing.d1,
        space: 0.0,
        indent: 0.0,
        endIndent: 0.0,
      ),
      dialogBackgroundColor: isDark ? kNeutralSwatch[7]! : kNeutralSwatch[1]!,
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.d24),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FludaX.x * 0.75),
        ),
        side: BorderSide(
          color: isDark ? Colors.white70 : Colors.black87,
          width: Spacing.d1 * 1.5,
        ),
      ),
    );
  }
}

class ThemeConfigs extends RefreshableBox {
  @override
  String get boxKey => ThemeDataKeys.key.toString();

  /// Singleton.
  static final ThemeConfigs _instance = ThemeConfigs._();

  factory ThemeConfigs() => _instance;

  ThemeConfigs._();
}
