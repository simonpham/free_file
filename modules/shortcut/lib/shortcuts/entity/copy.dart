import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:utils/constants/constants.dart';

class CopyAction extends Action<CopyIntent> {
  final BuildContext context;

  CopyAction(this.context);

  @override
  void invoke(covariant CopyIntent intent) {
    injector<EventBus>().fire(
      const CopyEvent(),
    );
  }
}

class CopyIntent extends Intent {
  static LogicalKeySet? get keySet {
    return (kIsMacOs ? EntityContextAction.copyMacOs : EntityContextAction.copy)
        .keySet;
  }
}
