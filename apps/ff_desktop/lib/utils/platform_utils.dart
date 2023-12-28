import 'dart:io' as io;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:storage/storage.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class PlatformUtils {
  static Future<Error?> open(
    Uri uri, {
    Uri? workingDirectory,
  }) async {
    final result = await io.Process.run(
      kOpenProcess,
      [uri.toFilePath()],
      workingDirectory: workingDirectory?.toFilePath(),
    );

    if (result.exitCode != 0 &&
        result.stderr.contains('kLSApplicationNotFoundErr')) {
      return Error.noApplicationKnowsHowToOpenUrl;
    }

    if (result.exitCode != 0) {
      return Error.openFailed;
    }

    return null;
  }

  static Future<Error?> openQuickLook(
    List<String> paths, {
    Uri? workingDirectory,
  }) async {
    if (!kIsMacOs) {
      return Error.notSupported;
    }

    final result = await io.Process.run(
      kMacOsQuickLookProcess,
      ['-p', ...paths],
      workingDirectory: workingDirectory?.toFilePath(),
      runInShell: true,
    );

    if (result.exitCode != 0) {
      return Error.openFailed;
    }

    return null;
  }

  static Future<(String?, Error?)> compress(
    List<String> paths, {
    String fileName = 'archive',
    required Uri workingDirectory,
  }) async {
    if (!kIsMacOs) {
      return (null, Error.notSupported);
    }

    String zipFilePath = '${workingDirectory.toFilePath()}$kSlash$fileName';
    int count = 1;
    while (await io.File('$zipFilePath.zip').exists()) {
      zipFilePath = '$zipFilePath-$count';
      count++;
    }

    /// Convert paths to relative paths.
    paths = paths.map((path) {
      return path.replaceFirst('${workingDirectory.toFilePath()}$kSlash', '');
    }).toList();

    zipFilePath = '$zipFilePath.zip';
    final result = await io.Process.run(
      kZipProcess,
      [
        '-r',
        zipFilePath,
        ...paths,
      ],
      workingDirectory: workingDirectory.toFilePath(),
    );

    if (result.exitCode != 0) {
      return (null, Error.compressFailed);
    }

    return (zipFilePath, null);
  }

  static Future<void> setupWindow() async {
    try {
      await Window.initialize();
      await Window.setEffect(
        effect: WindowEffect.acrylic,
      );
    } catch (_) {}

    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }

  static bool watchTransparencySetting(BuildContext context) {
    final enableTransparency =
        context.select((ThemeModel _) => _.enableTransparency);
    final isDarkMode =
        context.select((ThemeModel _) => _.themeMode == ThemeMode.dark);
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
      if (injector.isRegistered<ThemeModel>()) {
        injector<ThemeModel>().refresh();
      }
      if (injector.isRegistered<TabViewModel>()) {
        final model = injector<TabViewModel>();
        model.refreshClipboard();
        model.currentExploreViewModel.refresh(maintainState: true);
      }
    }
  }

  static String getVolumesPath() {
    if (kIsMacOs) {
      return '/Volumes/';
    }

    return '';
  }
}
