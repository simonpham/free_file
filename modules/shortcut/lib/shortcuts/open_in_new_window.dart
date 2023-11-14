import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class OpenInNewWindowAction extends Action<OpenInNewWindowIntent> {
  final BuildContext context;

  OpenInNewWindowAction(this.context);

  @override
  void invoke(covariant OpenInNewWindowIntent intent) {
    injector<EventBus>().fire(
      const OpenInNewWindowEvent(),
    );
  }
}

class OpenInNewWindowIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.openInNewWindow.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.openInNewWindow.shortcutKey.toSet(),
            )
          : null;
}
