import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class PropertiesAction extends Action<PropertiesIntent> {
  final BuildContext context;

  PropertiesAction(this.context);

  @override
  void invoke(covariant PropertiesIntent intent) {
    injector<EventBus>().fire(
      const PropertiesEvent(),
    );
  }
}

class PropertiesIntent extends Intent {
  static LogicalKeySet? get keySet =>
      EntityContextAction.properties.shortcutKey.isNotEmpty
          ? LogicalKeySet.fromSet(
              EntityContextAction.properties.shortcutKey.toSet(),
            )
          : null;
}
