import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class CopyMacOsAction extends Action<CopyMacOsIntent> {
  final BuildContext context;

  CopyMacOsAction(this.context);

  @override
  void invoke(covariant CopyMacOsIntent intent) {
    injector<EventBus>().fire(
      const CopyMacOsEvent(),
    );
  }
}

class CopyMacOsIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.copyMacOs.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.copyMacOs.shortcutKey.toSet(),
            )
          : null;
}
