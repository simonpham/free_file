import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class OpenAction extends Action<OpenIntent> {
  final BuildContext context;

  OpenAction(this.context);

  @override
  void invoke(covariant OpenIntent intent) {
    injector<EventBus>().fire(
      const OpenEvent(),
    );
  }
}

class OpenIntent extends Intent {
  static LogicalKeySet? get keySet => EntityContextAction.open.keySet;
}
