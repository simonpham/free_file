import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utils/constants/constants.dart';

class CloseTabAction extends Action<CloseTabIntent> {
  CloseTabAction();

  @override
  void invoke(covariant CloseTabIntent intent) {
    injector<EventBus>().fire(
      const CloseTabEvent(),
    );
  }
}

class CloseTabIntent extends Intent {
  static LogicalKeySet get keySet => kIsMacOs
      ? LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyW)
      : LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyW);
}
