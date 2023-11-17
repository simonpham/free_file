import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class CompressAction extends Action<CompressIntent> {
  final BuildContext context;

  CompressAction(this.context);

  @override
  void invoke(covariant CompressIntent intent) {
    injector<EventBus>().fire(
      const CompressEvent(),
    );
  }
}

class CompressIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.compress.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.compress.shortcutKey.toSet(),
            )
          : null;
}
