import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/theme.dart';

enum WorkspaceActions {
  addTab,
  closeTab,
  closeAllTabs,
  nextTab,
  previousTab;

  List<LogicalKeyboardKey> get shortcutKey {
    return ThemeConfigs().workspaceShortcut.items[name]?.shortcutKey ??
        const [];
  }

  LogicalKeySet? get keySet {
    final shortcutKey = this.shortcutKey;
    if (shortcutKey.isEmpty) {
      return null;
    }

    return LogicalKeySet.fromSet(
      shortcutKey.toSet(),
    );
  }
}
