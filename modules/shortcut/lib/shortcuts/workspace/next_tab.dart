import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class NextTabAction extends Action<NextTabIntent> {
  NextTabAction();

  @override
  void invoke(covariant NextTabIntent intent) {
    injector<EventBus>().fire(
      const NextTabEvent(),
    );
  }
}

class NextTabIntent extends Intent {
  static LogicalKeySet? get keySet => WorkspaceActions.nextTab.keySet;
}
