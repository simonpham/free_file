import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class WindowServiceInterface extends ChangeNotifier {
  Future<void> openNewWindow(String path);

  bool get isWindowMode;

  Future<void> toggleWindowMode();

  Future<void> initialize();
}
