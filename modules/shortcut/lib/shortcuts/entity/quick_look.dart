import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class QuickLookAction extends Action<QuickLookIntent> {
  final BuildContext context;

  QuickLookAction(this.context);

  @override
  void invoke(covariant QuickLookIntent intent) {
    injector<EventBus>().fire(
      const QuickLookEvent(),
    );
  }
}

class QuickLookIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.quickLook.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.quickLook.shortcutKey.toSet(),
            )
          : null;
}
