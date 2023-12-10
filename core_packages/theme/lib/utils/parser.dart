import 'package:flutter/services.dart';

class KeyParser {
  static LogicalKeyboardKey? parse(String keyLabel) {
    switch (keyLabel) {
      case 'Enter':
        return LogicalKeyboardKey.enter;
      case 'Alt':
        return LogicalKeyboardKey.alt;
      case 'Space':
        return LogicalKeyboardKey.space;
      case 'Meta':
        return LogicalKeyboardKey.meta;
      case 'Control':
        return LogicalKeyboardKey.control;
      case 'Delete':
        return LogicalKeyboardKey.delete;
      case 'Shift':
        return LogicalKeyboardKey.shift;
      case 'F2':
        return LogicalKeyboardKey.f2;
      case 'KeyC':
        return LogicalKeyboardKey.keyC;
      case 'KeyV':
        return LogicalKeyboardKey.keyV;
      default:
        return null;
    }
  }
}
