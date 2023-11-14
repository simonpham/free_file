import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:desktop_multi_window/desktop_multi_window.dart';

import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/router.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:shortcut/shortcut.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class FreeFileLaunchArgument {
  final String? path;

  const FreeFileLaunchArgument({
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      'path': path,
    };
  }

  factory FreeFileLaunchArgument.fromJson(Map<String, dynamic> json) {
    return FreeFileLaunchArgument(
      path: json['path'] as String?,
    );
  }
}

class FreeFile extends StatefulWidget {
  final WindowController? windowController;
  final FreeFileLaunchArgument? launchArgument;

  const FreeFile({
    super.key,
    this.windowController,
    this.launchArgument,
  });

  @override
  State<FreeFile> createState() => _FreeFileState();
}

class _FreeFileState extends State<FreeFile> {
  ThemeModel get themeModel => injector<ThemeModel>();

  @override
  Widget build(BuildContext context) {
    final size = ScreenSize.of(context);
    themeModel.screenSize = size;
    return GlobalShortcutWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: injector<TabViewModel>(),
          ),
          ChangeNotifierProvider.value(
            value: themeModel,
          ),
        ],
        builder: (BuildContext context, _) {
          final themeMode = context.select((ThemeModel _) => _.themeMode);
          return MaterialApp.router(
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            theme: ThemeConfigs().getThemeData(ThemeMode.light),
            darkTheme: ThemeConfigs().getThemeData(ThemeMode.dark),
            builder: (context, child) {
              return Container(
                color: PlatformUtils.watchTransparencySetting(context)
                    ? Color.lerp(
                        context.theme.primaryColor,
                        (themeMode == ThemeMode.dark
                            ? Colors.black54
                            : Colors.white70),
                        0.95,
                      )
                    : Color.lerp(
                        context.theme.primaryColor,
                        (themeMode == ThemeMode.dark
                            ? Colors.black
                            : Colors.white),
                        0.95,
                      ),
                child: ContextMenuOverlay(
                  cardBuilder: ThemeConfigs().contextCardBuilder,
                  buttonBuilder: ThemeConfigs().contextMenuButtonBuilder,
                  dividerBuilder: ThemeConfigs().contextMenuDividerBuilder,
                  child: Stack(
                    children: [
                      if (child != null)
                        Positioned.fill(
                          child: child,
                        ),
                      const Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: WindowTitleBar(),
                      ),
                    ],
                  ),
                ),
              );
            },
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
