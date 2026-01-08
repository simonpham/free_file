import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/router.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:l10n/l10n.dart';
import 'package:shortcut/shortcut.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class FreeFileLaunchArgument {
  final String? path;

  const FreeFileLaunchArgument({this.path});

  Map<String, dynamic> toJson() {
    return {'path': path};
  }

  factory FreeFileLaunchArgument.fromJson(Map<String, dynamic> json) {
    return FreeFileLaunchArgument(path: json['path'] as String?);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class FreeFile extends StatefulWidget {
  final String? initialPath;

  const FreeFile({super.key, this.initialPath});

  @override
  State<FreeFile> createState() => _FreeFileState();
}

class _FreeFileState extends State<FreeFile> {
  ThemeModel get themeModel => injector<ThemeModel>();
  final LocaleModel localeModel = LocaleModel();

  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Delay initialization to allow irondash_engine_context to complete async
    // FlutterView registration. This prevents super_native_extensions from
    // crashing when DropRegion tries to access FlutterView before it's ready.
    // The async registration happens via dispatch_async(dispatch_get_main_queue())
    // in the native plugin code.
    await Future.delayed(const Duration(milliseconds: 200));

    // If we have an initial path, navigate to it
    if (widget.initialPath != null) {
      final tabViewModel = injector<TabViewModel>();
      tabViewModel.currentExploreViewModel.goTo(
        Uri.directory(widget.initialPath!),
      );
    }

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until ready
    if (!_isReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeConfigs().getThemeData(ThemeMode.light),
        darkTheme: ThemeConfigs().getThemeData(ThemeMode.dark),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final size = ScreenSize.of(context);
    themeModel.screenSize = size;
    return GlobalShortcutWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: injector<TabViewModel>()),
          ChangeNotifierProvider.value(value: themeModel),
          ChangeNotifierProvider.value(value: localeModel),
        ],
        builder: (BuildContext context, _) {
          return Consumer2<ThemeModel, LocaleModel>(
            builder: (context, themeModel, localeModel, _) {
              final themeMode = themeModel.themeMode;
              return MaterialApp.router(
                themeMode: themeMode,
                locale: localeModel.locale,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.supportedLocales,
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
                          if (child != null) Positioned.fill(child: child),
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
          );
        },
      ),
    );
  }
}
