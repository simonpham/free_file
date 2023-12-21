import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class SelectAllAction extends Action<SelectAllIntent> {
  final BuildContext context;

  SelectAllAction(this.context);

  @override
  void invoke(covariant SelectAllIntent intent) {
    injector<EventBus>().fire(
      const SelectAllEvent(),
    );
  }
}

class SelectAllIntent extends Intent {
  static LogicalKeySet? get keySet => EntityContextAction.selectAll.keySet;
}