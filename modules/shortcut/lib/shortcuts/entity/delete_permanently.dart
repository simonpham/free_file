import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class DeletePermanentlyAction extends Action<DeletePermanentlyIntent> {
  final BuildContext context;

  DeletePermanentlyAction(this.context);

  @override
  void invoke(covariant DeletePermanentlyIntent intent) {
    injector<EventBus>().fire(
      const DeletePermanentlyEvent(),
    );
  }
}

class DeletePermanentlyIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.deletePermanently.keySet;
}
