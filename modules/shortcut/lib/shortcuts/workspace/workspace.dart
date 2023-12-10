import 'package:flutter/material.dart';
import 'package:shortcut/shortcut.dart';

export 'add_tab.dart';
export 'close_all_tabs.dart';
export 'close_tab.dart';
export 'next_tab.dart';
export 'previous_tab.dart';

class WorkspaceShortcuts {
  static Map<LogicalKeySet?, Intent> get workspaceShortcuts =>
      <LogicalKeySet?, Intent>{
        AddTabIntent.keySet: AddTabIntent(),
        CloseAllTabsIntent.keySet: CloseAllTabsIntent(),
        CloseTabIntent.keySet: CloseTabIntent(),
        NextTabIntent.keySet: NextTabIntent(),
        PreviousTabIntent.keySet: PreviousTabIntent(),
      };

  static Map<Type, Action<Intent>> getWorkspaceActions(
    BuildContext context,
  ) {
    return <Type, Action<Intent>>{
      AddTabIntent: AddTabAction(),
      CloseTabIntent: CloseTabAction(),
      CloseAllTabsIntent: CloseAllTabsAction(),
      NextTabIntent: NextTabAction(),
      PreviousTabIntent: PreviousTabAction(),
    };
  }
}
