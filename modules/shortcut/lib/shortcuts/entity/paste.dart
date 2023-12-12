import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class PasteAction extends Action<PasteIntent> {
  final BuildContext context;

  PasteAction(this.context);

  @override
  void invoke(covariant PasteIntent intent) {
    injector<EventBus>().fire(
      const PasteEvent(),
    );
  }
}

class PasteIntent extends Intent {
  static LogicalKeySet? get keySet {
    return EntityContextAction.paste.keySet;
  }
}
