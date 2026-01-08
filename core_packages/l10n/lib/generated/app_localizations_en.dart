// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get actionOpen => 'Open';

  @override
  String get actionOpenInNewWindow => 'Open in new window';

  @override
  String get actionOpenInNewWindows => 'Open in new windows';

  @override
  String get actionOpenInNewTab => 'Open in new tab';

  @override
  String get actionOpenInNewTabs => 'Open in new tabs';

  @override
  String get actionPinToSidebar => 'Pin to sidebar';

  @override
  String get actionUnpinFromSidebar => 'Unpin from sidebar';

  @override
  String get actionQuickLook => 'Quick look';

  @override
  String get actionCompress => 'Compress';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionPaste => 'Paste';

  @override
  String actionPasteItems(int count) {
    return 'Paste $count items here';
  }

  @override
  String actionPasteItem(String name) {
    return 'Paste \"$name\" here';
  }

  @override
  String get actionMove => 'Move';

  @override
  String actionMoveItems(int count) {
    return 'Move $count items here';
  }

  @override
  String actionMoveItem(String name) {
    return 'Move \"$name\" here';
  }

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionDeletePermanently => 'Delete permanently';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionProperties => 'Properties';

  @override
  String get actionSelectAll => 'Select all';

  @override
  String get actionToggleShowHiddenFiles => 'Toggle show hidden files';

  @override
  String get actionUnknown => 'Unknown';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogDelete => 'Delete';

  @override
  String dialogDeleteContent(int count) {
    return 'Are you sure you want to delete $count items?';
  }

  @override
  String get dialogDeletePermanently => 'Delete Permanently';

  @override
  String dialogDeletePermanentlyContent(int count) {
    return 'Are you sure you want to delete $count items permanently?';
  }

  @override
  String get search => 'Search';

  @override
  String get root => 'Root';

  @override
  String get home => 'Home';

  @override
  String get pinned => 'Pinned';

  @override
  String get cloud => 'Cloud';

  @override
  String get yours => 'Yours';

  @override
  String get drives => 'Drives';

  @override
  String get tags => 'Tags';

  @override
  String get homePage => 'Home Page';

  @override
  String get keySpace => 'Space';

  @override
  String get keyShift => 'Shift';

  @override
  String get keyAlt => 'Alt';

  @override
  String get keyCtrl => 'Ctrl';

  @override
  String get keyWindows => 'Windows';

  @override
  String get keySuper => 'Super';

  @override
  String statusItems(int count) {
    return '$count items';
  }

  @override
  String get headerName => 'Name';

  @override
  String get headerDateModified => 'Date Modified';

  @override
  String get headerKind => 'Kind';

  @override
  String get kindFolder => 'Folder';

  @override
  String get kindDocument => 'Document';

  @override
  String kindFile(String extension) {
    return '$extension File';
  }

  @override
  String get viewModeList => 'List';

  @override
  String get viewModeGrid => 'Grid';

  @override
  String get viewModeDetails => 'Details';

  @override
  String get switchWindowMode => 'Switch Window Mode';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}
