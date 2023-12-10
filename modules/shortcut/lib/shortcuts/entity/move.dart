import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class MoveAction extends Action<MoveIntent> {
  final BuildContext context;

  MoveAction(this.context);

  @override
  void invoke(covariant MoveIntent intent) {
    injector<EventBus>().fire(
      const MoveEvent(),
    );
  }
}

class MoveIntent extends Intent {
  static LogicalKeySet? get keySet => EntityContextAction.move.keySet;
}
