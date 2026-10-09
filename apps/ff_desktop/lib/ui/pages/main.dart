import 'package:ff_desktop/ui/ui.dart';
import 'package:file_explorer/file_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FileExplorerPage(
      tabBarTrailing: const WindowModeToggle(),
      sideBarWrapper: (child) => TitlebarSafeArea(child: child),
    );
  }
}
