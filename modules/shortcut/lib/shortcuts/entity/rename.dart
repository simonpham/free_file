import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class RenameAction extends Action<RenameIntent> {
  final BuildContext context;

  RenameAction(this.context);

  @override
  void invoke(covariant RenameIntent intent) {
    injector<EventBus>().fire(
      const RenameEvent(),
    );
  }
}

class RenameIntent extends Intent {
  static LogicalKeySet? get keySet => EntityContextAction.rename.keySet;
}
