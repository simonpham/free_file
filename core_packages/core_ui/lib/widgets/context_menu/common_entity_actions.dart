import 'package:core_ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utils/constants/constants.dart';

enum EntityContextAction {
  open(
    shortcutKey: [LogicalKeyboardKey.enter],
  ),
  openInNewWindow(
    showOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.enter,
    ],
  ),
  openInNewTab,
  quickLook(
    shortcutKey: [LogicalKeyboardKey.space],
  ),
  compress,
  copyMacOs(
    isMacOsOnly: true,
    isCompact: true,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyC,
    ],
  ),
  copy(
    isCompact: true,
    hideOnMacOs: true,
    shortcutKey: [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyC,
    ],
  ),
  paste(
    isCompact: true,
    hideOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyV,
    ],
  ),
  pasteMacOs(
    isCompact: true,
    hideOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyV,
    ],
  ),
  move(
    isCompact: true,
    showOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyV,
    ],
  ),
  delete(
    isCompact: true,
    hideOnKeyHold: LogicalKeyboardKey.shift,
    shortcutKey: [LogicalKeyboardKey.delete],
  ),
  deletePermanently(
    isCompact: true,
    showOnKeyHold: LogicalKeyboardKey.shift,
    shortcutKey: [
      LogicalKeyboardKey.shift,
      LogicalKeyboardKey.delete,
    ],
  ),
  rename(isCompact: true, shortcutKey: [LogicalKeyboardKey.f2]),
  properties(
    shortcutKey: [
      LogicalKeyboardKey.alt,
      LogicalKeyboardKey.space,
    ],
  );

  final bool isCompact;
  final bool isMacOsOnly;
  final bool hideOnMacOs;
  final List<LogicalKeyboardKey> shortcutKey;
  final LogicalKeyboardKey? showOnKeyHold;
  final LogicalKeyboardKey? hideOnKeyHold;

  const EntityContextAction({
    this.isCompact = false,
    this.isMacOsOnly = false,
    this.hideOnMacOs = false,
    this.showOnKeyHold,
    this.hideOnKeyHold,
    this.shortcutKey = const [],
  });

  SvgGenImage? get icon {
    return switch (this) {
      open => null,
      openInNewWindow => Assets.icons.arrows.outline.maximize,
      openInNewTab => Assets.icons.interface.outline.addRectangle,
      quickLook => Assets.icons.interface.outline.eye01,
      compress => Assets.icons.filesAndFolder.outline.archiveAdd,
      copy => Assets.icons.interface.outline.copy,
      copyMacOs => Assets.icons.interface.outline.copy,
      paste => null,
      pasteMacOs => null,
      move => null,
      delete => Assets.icons.interface.outline.trash,
      deletePermanently => Assets.icons.interface.outline.trash01,
      rename => Assets.icons.interface.outline.edit,
      properties => null,
    };
  }

  String getLabel(BuildContext context) {
    return switch (this) {
      open => 'Open',
      openInNewWindow => 'Open in new window',
      openInNewTab => 'Open in new tab',
      quickLook => 'Quick look',
      compress => 'Compress',
      copy => 'Copy',
      copyMacOs => 'Copy',
      paste => 'Paste',
      pasteMacOs => 'Paste',
      move => 'Move',
      delete => 'Delete',
      deletePermanently => 'Delete permanently',
      rename => 'Rename',
      properties => 'Properties',
    };
  }

  String get shortcutLabel {
    final shortcutKey = this.shortcutKey;
    if (shortcutKey.isEmpty) return '';
    return shortcutKey
        .map((e) => e.getLabel())
        .skipWhile((e) => e.isEmpty)
        .join(' + ');
  }

  bool get enabled {
    if (isMacOsOnly && !kIsMacOs) {
      return false;
    }
    if (hideOnMacOs && kIsMacOs) {
      return false;
    }
    return true;
  }

  static Iterable<EntityContextAction> get availableActions {
    return EntityContextAction.values.where((item) => item.enabled);
  }
}

extension on LogicalKeyboardKey {
  String getLabel() {
    switch (this) {
      case LogicalKeyboardKey.space:
        return kSpaceKeyLabel;
      case LogicalKeyboardKey.meta:
        return kMetaKeyLabel;
      case LogicalKeyboardKey.alt:
        return kAltKeyLabel;
      case LogicalKeyboardKey.control:
        return kCtrlKeyLabel;
      case LogicalKeyboardKey.shift:
        return kShiftKeyLabel;
      default:
        return keyLabel;
    }
  }
}
