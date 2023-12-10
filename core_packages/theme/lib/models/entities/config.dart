part of 'theme_configs.dart';

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
