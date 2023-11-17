import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class DeleteAction extends Action<DeleteIntent> {
  final BuildContext context;

  DeleteAction(this.context);

  @override
  void invoke(covariant DeleteIntent intent) {
    injector<EventBus>().fire(
      const DeleteEvent(),
    );
  }
}

class DeleteIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.delete.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.delete.shortcutKey.toSet(),
            )
          : null;
}
