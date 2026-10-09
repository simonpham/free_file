import 'dart:async';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:ff_desktop/services/services.dart';
import 'package:file_explorer/file_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:storage/storage.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class PlatformUtils {
  static Future<void> setupWindow() async {
    final windowService = injector<WindowService>();
    await windowService.initialize();
  }

  static bool watchTransparencySetting(BuildContext context) {
    final enableTransparency = context.select(
      (ThemeModel model) => model.enableTransparency,
    );
    final isDarkMode = context.select(
      (ThemeModel model) => model.themeMode == ThemeMode.dark,
    );

    if (!injector<WindowService>().isWindowMode) {
      return enableTransparency;
    }

    try {
      Window.setEffect(
        effect: enableTransparency && !kIsLinux
            ? WindowEffect.acrylic
            : WindowEffect.solid,
        color: isDarkMode ? Colors.black : Colors.white,
        dark: isDarkMode,
      );
    } catch (_) {}

    return enableTransparency;
  }

  static void listenToWindowStatus() {
    DesktopLifecycle.instance.isActive.removeListener(onWindowStatusChange);
    DesktopLifecycle.instance.isActive.addListener(onWindowStatusChange);
  }

  static Future<void> onWindowStatusChange() async {
    if (DesktopLifecycle.instance.isActive.value) {
      await Settings().reload();
      await SystemTheme.accentColor.load();
      if (injector.isRegistered<ThemeModel>()) {
        injector<ThemeModel>().refresh();
      }
      if (injector.isRegistered<TabViewModel>()) {
        final model = injector<TabViewModel>();
        unawaited(model.refreshClipboard());
        unawaited(model.currentExploreViewModel.refresh(maintainState: true));
      }
    }
  }
}
