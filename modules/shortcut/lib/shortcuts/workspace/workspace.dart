import 'package:flutter/material.dart';
import 'package:shortcut/shortcut.dart';

export 'add_tab.dart';
export 'close_tab.dart';

class WorkspaceShortcuts {
  static Map<LogicalKeySet?, Intent> get workspaceShortcuts =>
      <LogicalKeySet?, Intent>{
        AddTabIntent.keySet: AddTabIntent(),
        CloseTabIntent.keySet: CloseTabIntent(),
      };

  static Map<Type, Action<Intent>> getWorkspaceActions(
    BuildContext context,
  ) {
    return <Type, Action<Intent>>{
      AddTabIntent: AddTabAction(),
      CloseTabIntent: CloseTabAction(),
    };
  }
}
