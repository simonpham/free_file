import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:ff_desktop/app.dart';
import 'package:ff_desktop/di.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:storage/storage.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Settings().init();
  await ThemeConfigs.init();
  await Injector.setup();

  await PlatformUtils.setupWindow();
  PlatformUtils.listenToWindowStatus();

  if (args case [String tag, String windowIdString, String argument]) {
    final int? windowId = int.tryParse(windowIdString);
    if (tag == 'multi_window' && windowId != null) {
      final launchArgument = FreeFileLaunchArgument.fromJson(
        jsonDecode(argument),
      );
      runApp(
        FreeFile(
          windowController: WindowController.fromWindowId(windowId),
          launchArgument: launchArgument,
        ),
      );
      return;
    }
  }

  runApp(
    const FreeFile(),
  );
}
