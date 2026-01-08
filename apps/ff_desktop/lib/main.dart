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

  // Parse command-line arguments for --open flag
  String? initialPath;
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--open' && i + 1 < args.length) {
      initialPath = args[i + 1];
      break;
    }
  }

  runApp(FreeFile(initialPath: initialPath));
}
