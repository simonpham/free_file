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

final kActionKey =
    kIsMacOs ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control;

final kSpaceKeyLabel = kIsMacOs ? '␣' : 'Space';
final kShiftKeyLabel = kIsMacOs ? '⇧' : 'Shift';
final kAltKeyLabel = kIsMacOs ? '⌥' : 'Alt';
final kCtrlKeyLabel = kIsMacOs ? '⌃' : 'Ctrl';
final kMetaKeyLabel = kIsMacOs
    ? '⌘'
    : kIsLinux
        ? '❖ Super'
        : 'Windows';

final kSlash = kIsWindows ? '\\' : '/';

const kMacOsDsStore = '.DS_Store';
const kMacOsQuickLookProcess = 'qlmanage';

const kZipProcess = 'zip';

const kWindowsInvalidFileNameRegex = r'[<>:"/\\|?*]';

final kOpenProcess = kIsMacOs
    ? 'open'
    : kIsWindows
        ? 'start'
        : 'xdg-open';
