part of 'constants.dart';

final kIsWeb = UniversalPlatform.isWeb;
final kIsDesktop = UniversalPlatform.isWindows || UniversalPlatform.isMacOS;
final kIsMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

final kIsWindows = UniversalPlatform.isWindows;
final kIsMacOs = UniversalPlatform.isMacOS;
final kIsLinux = UniversalPlatform.isLinux;

final kIsAndroid = UniversalPlatform.isAndroid;
final kIsIoS = UniversalPlatform.isIOS;

final kIsFuchsia = UniversalPlatform.isFuchsia;

final kSlash = kIsWindows ? '\\' : '/';
