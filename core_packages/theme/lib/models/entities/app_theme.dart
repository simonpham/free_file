part of 'theme_configs.dart';

extension ThemeExtension on BuildContext {
  AppTheme get appTheme =>
      select((ThemeModel _) => _.themeMode == ThemeMode.dark)
          ? ThemeConfigs().darkTheme
          : ThemeConfigs().lightTheme;
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
