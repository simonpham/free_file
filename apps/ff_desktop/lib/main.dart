import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:core/core.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:ff_desktop/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:go_router/go_router.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:ff_desktop/features/home/ui/ui.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Window.initialize();
    await Window.setEffect(
      effect: WindowEffect.acrylic,
      color: const Color(0xCC222222),
    );
  } catch (_) {}

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });


  final EntityProvider entityProvider = LocalEntityProvider();
  final entities = await entityProvider.list(Uri(path: '/'));
  for (final entity in entities) {
    debugPrint(entity.path.path);
  }

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

final appRouter = GoRouter(
  initialLocation: HomePage.routePath,
  routes: [
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routePath,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
