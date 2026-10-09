import 'dart:async';
import 'dart:io' as io;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_explorer/file_explorer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:storage/storage.dart';
import 'package:utils/utils.dart';

class WindowService extends WindowServiceInterface {
  @override
  Future<void> openNewWindow(String path) async {
    try {
      final executablePath = io.Platform.resolvedExecutable;
      await io.Process.start(executablePath, [
        '--open',
        path,
      ], mode: io.ProcessStartMode.detached);
    } catch (err, trace) {
      printError(err, trace);
    }
  }

  bool _isWindowMode = Settings().windowMode;

  @override
  bool get isWindowMode => _isWindowMode;

  static const _channel = MethodChannel('flutter/window_mode');

  @override
  Future<void> toggleWindowMode() async {
    if (!kIsMacOs) return;

    _isWindowMode = !_isWindowMode;
    Settings().windowMode = _isWindowMode;
    notifyListeners();

    await _channel.invokeMethod('toggleWindowMode');

    unawaited(_initWindowStyle());
  }

  @override
  Future<void> initialize() async {
    unawaited(_initWindowStyle());

    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;

      if (_isWindowMode) {
        appWindow.show();
      }
    });
  }

  Future<void> _initWindowStyle() async {
    if (!_isWindowMode) {
      return;
    }

    try {
      await Window.initialize();
      if (kIsMacOs) {
        unawaited(Window.addToolbar());
        unawaited(
          Window.setToolbarStyle(
            toolbarStyle: MacOSToolbarStyle.unifiedCompact,
          ),
        );
      }
      if (kIsMacOs || kIsWindows) {
        await Window.setEffect(effect: WindowEffect.acrylic);
      }
    } catch (_) {}
  }
}
