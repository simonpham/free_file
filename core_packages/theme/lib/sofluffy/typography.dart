part of 'sofluffy_theme.dart';

extension on TextStyle? {
  TextStyle get safe {
    return this ?? const TextStyle();
  }
}

extension ThemeExt on BuildContext {
  Color get typoColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[1]!
        : kNeutralSwatch[7]!;
  }

  Color get typoReverseColor {
    return ThemeConfigs().themeMode != ThemeMode.dark
        ? kNeutralSwatch[1]!
        : kNeutralSwatch[7]!;
  }

  Color get typoFadeColor {
    return kNeutralSwatch[4]!;
  }

  Color get onPrimaryColor {
    return kNeutralSwatch[1]!;
  }

  Color get chipBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[5]!.withOpacity(0.5)
        : kNeutralSwatch[3]!;
  }

  Color get chipButtonTypoColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[3]!
        : kNeutralSwatch[6]!;
  }

  Color get myMessageBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[5]!.withOpacity(0.5)
        : kNeutralSwatch[1]!;
  }

  Color get otherMessageBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[7]!.withTransparency
        : kNeutralSwatch[2]!;
  }

  Color get dividerColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[5]!
        : kNeutralSwatch[3]!;
  }

  Color get secondarySideBarBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[6]!
        : kNeutralSwatch[1]!;
  }

  Color get contextMenuBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[6]!
        : kNeutralSwatch[1]!;
  }

  Color get inlineCodeBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[4]!.withOpacity(0.5)
        : kNeutralSwatch[6]!.withOpacity(0.5);
  }

  Color get codeBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[6]!.withOpacity(0.5)
        : kNeutralSwatch[7]!;
  }

  Color get selectedCardBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[5]!.withTransparency
        : kNeutralSwatch[3]!.applyTransparencyWith(base: 0.75);
  }

  Color get checkBoxBorderColor {
    return kNeutralSwatch[4]!.withOpacity(0.5);
  }

  Color get searchItemHoveredBackgroundColor {
    return ThemeConfigs().themeMode == ThemeMode.dark
        ? kNeutralSwatch[6]!
        : kNeutralSwatch[3]!.withOpacity(0.5);
  }

  TextStyle get h1 {
    return theme.textTheme.displayLarge.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d64,
      fontWeight: FontWeight.w700,
      height: 0.93,
      letterSpacing: -0.03,
    );
  }

  TextStyle get h2 {
    return theme.textTheme.displayMedium.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d48,
      fontWeight: FontWeight.w700,
      height: 0.96,
      letterSpacing: -0.03,
    );
  }

  TextStyle get h3 {
    return theme.textTheme.displaySmall.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d40,
      fontWeight: FontWeight.w700,
      height: 0.99,
      letterSpacing: -0.05,
    );
  }

  TextStyle get h4 {
    return theme.textTheme.headlineMedium.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d28,
      fontWeight: FontWeight.w700,
      height: 1.18,
      letterSpacing: -0.02,
    );
  }

  TextStyle get h5 {
    return theme.textTheme.headlineSmall.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d24,
      fontWeight: FontWeight.w600,
      height: 1.38,
      letterSpacing: -0.03,
    );
  }

  TextStyle get h6 {
    return theme.textTheme.titleLarge.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d16 + Spacing.d2,
      fontWeight: FontWeight.w600,
      height: 1.47,
      letterSpacing: -0.03,
    );
  }

  TextStyle get body1 {
    return theme.textTheme.bodyLarge.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d24,
      fontWeight: FontWeight.w400,
      height: 1.28,
      letterSpacing: -0.03,
    );
  }

  TextStyle get body2 {
    return theme.textTheme.bodyMedium.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d16 + Spacing.d1,
      fontWeight: FontWeight.w400,
      height: 1.21,
      letterSpacing: -0.01,
    );
  }

  TextStyle get base1 {
    return theme.textTheme.bodyLarge.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d16,
      fontWeight: FontWeight.w500,
      height: 1.24,
      letterSpacing: -0.03,
    );
  }

  TextStyle get base2 {
    return theme.textTheme.bodyMedium.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d16 - Spacing.d2,
      fontWeight: FontWeight.w500,
      height: 1.42,
      letterSpacing: -0.02,
    );
  }

  TextStyle get caption1 {
    return theme.textTheme.bodySmall.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d12,
      fontWeight: FontWeight.w500,
      height: 1.38,
      letterSpacing: -0.03,
    );
  }

  TextStyle get caption2 {
    return theme.textTheme.bodySmall.safe.copyWith(
      color: typoColor,
      fontSize: Spacing.d12 - Spacing.d1,
      fontWeight: FontWeight.w500,
      height: 1.20,
      letterSpacing: -0.01,
    );
  }
}
