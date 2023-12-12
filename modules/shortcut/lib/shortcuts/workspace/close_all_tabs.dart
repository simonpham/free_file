import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class CloseAllTabsAction extends Action<CloseAllTabsIntent> {
  CloseAllTabsAction();

  @override
  void invoke(covariant CloseAllTabsIntent intent) {
    injector<EventBus>().fire(
      const CloseAllTabsEvent(),
    );
  }
}

class CloseAllTabsIntent extends Intent {
  static LogicalKeySet? get keySet => WorkspaceActions.closeAllTabs.keySet;
}
