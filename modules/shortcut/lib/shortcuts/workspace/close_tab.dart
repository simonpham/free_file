import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class CloseTabAction extends Action<CloseTabIntent> {
  CloseTabAction();

  @override
  void invoke(covariant CloseTabIntent intent) {
    injector<EventBus>().fire(
      const CloseTabEvent(),
    );
  }
}

class CloseTabIntent extends Intent {
  static LogicalKeySet? get keySet => WorkspaceActions.closeTab.keySet;
}
