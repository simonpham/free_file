import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ToggleShowHiddenAction extends Action<ToggleShowHiddenIntent> {
  final BuildContext context;

  ToggleShowHiddenAction(this.context);

  @override
  void invoke(covariant ToggleShowHiddenIntent intent) {
    injector<EventBus>().fire(const ToggleShowHiddenEvent());
  }
}

class ToggleShowHiddenIntent extends Intent {
  static LogicalKeySet? get keySet {
    return EntityContextAction.toggleShowHidden.keySet;
  }
}
