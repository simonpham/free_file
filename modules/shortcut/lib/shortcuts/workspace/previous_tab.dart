import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class PreviousTabAction extends Action<PreviousTabIntent> {
  PreviousTabAction();

  @override
  void invoke(covariant PreviousTabIntent intent) {
    injector<EventBus>().fire(
      const PreviousTabEvent(),
    );
  }
}

class PreviousTabIntent extends Intent {
  static LogicalKeySet? get keySet => WorkspaceActions.previousTab.keySet;
}
