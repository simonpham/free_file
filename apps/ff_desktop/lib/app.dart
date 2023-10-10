import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:ff_desktop/router.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';

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

class FreeFile extends StatelessWidget {
  final WindowController? windowController;
  final FreeFileLaunchArgument? launchArgument;

  const FreeFile({
    super.key,
    this.windowController,
    this.launchArgument,
  });

  @override
  Widget build(BuildContext context) {
    final size = ScreenSize.of(context);
    ThemeConfigs().screenSize = size;
    print('Screen Size: $size');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeConfigs(),
        ),
      ],
      builder: (BuildContext context, _) {
        return MaterialApp.router(
          color: Colors.transparent,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          theme: context.select(
            (ThemeConfigs _) => _.getThemeData(ThemeMode.light),
          ),
          darkTheme: context.select(
            (ThemeConfigs _) => _.getThemeData(ThemeMode.dark),
          ),
          builder: (context, child) {
            return Stack(
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
            );
          },
          routerConfig: appRouter,
        );
      },
    );
  }
}
