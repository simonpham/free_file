import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class OpenInNewTabAction extends Action<OpenInNewTabIntent> {
  final BuildContext context;

  OpenInNewTabAction(this.context);

  @override
  void invoke(covariant OpenInNewTabIntent intent) {
    injector<EventBus>().fire(
      const OpenInNewTabEvent(),
    );
  }
}

class OpenInNewTabIntent extends Intent {
  static LogicalKeySet? get keySet => EntityContextAction.openInNewTab.keySet;
}
