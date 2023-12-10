part of 'theme_configs.dart';

@immutable
class Shortcut {
  final Map<String, ShortcutConfig> items;

  const Shortcut({
    required this.items,
  });

  factory Shortcut.fromJson(Map<String, dynamic> json) {
    final items = <String, ShortcutConfig>{};
    for (final entry in json.entries) {
      final action = entry.key;
      final config = ShortcutConfig.fromJson(entry.value);
      items[action] = config;
    }
    return Shortcut(items: items);
  }
}

@immutable
class ShortcutConfig {
  final List<LogicalKeyboardKey> shortcutKey;
  final LogicalKeyboardKey? showOnKeyHold;
  final LogicalKeyboardKey? hideOnKeyHold;

  const ShortcutConfig({
    required this.shortcutKey,
    this.showOnKeyHold,
    this.hideOnKeyHold,
  });

  factory ShortcutConfig.fromJson(Map<String, dynamic> json) {
    final shortcutKey = json['shortcutKey'] is List
        ? json['shortcutKey']
            .map((e) => KeyParser.parse(e))
            .whereType<LogicalKeyboardKey>()
            .toList()
        : const <LogicalKeyboardKey>[];
    final showOnKeyHold = json['showOnKeyHold'] == null
        ? null
        : KeyParser.parse(json['showOnKeyHold']);
    final hideOnKeyHold = json['hideOnKeyHold'] == null
        ? null
        : KeyParser.parse(json['hideOnKeyHold']);
    return ShortcutConfig(
      shortcutKey: shortcutKey,
      showOnKeyHold: showOnKeyHold,
      hideOnKeyHold: hideOnKeyHold,
    );
  }
}
