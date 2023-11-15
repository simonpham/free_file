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
  ),
  openInNewTab(
    hideOnKeyHold: LogicalKeyboardKey.alt,
  ),
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
    hideOnMacOs: true,
    hideOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyV,
    ],
  ),
  pasteMacOs(
    isCompact: true,
    isMacOsOnly: true,
    hideOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyV,
    ],
  ),
  moveMacOs(
    isCompact: true,
    isMacOsOnly: true,
    showOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyV,
    ],
  ),
  move(
    isCompact: true,
    hideOnMacOs: true,
    showOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyV,
    ],
  ),
  delete(
    isCompact: true,
    hideOnMacOs: true,
    hideOnKeyHold: LogicalKeyboardKey.shift,
    shortcutKey: [LogicalKeyboardKey.delete],
  ),
  deleteMacOs(
    isCompact: true,
    isMacOsOnly: true,
    hideOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [LogicalKeyboardKey.delete],
  ),
  deletePermanentlyMacOs(
    isCompact: true,
    isMacOsOnly: true,
    showOnKeyHold: LogicalKeyboardKey.alt,
    shortcutKey: [
      LogicalKeyboardKey.alt,
      LogicalKeyboardKey.delete,
    ],
  ),
  deletePermanently(
    isCompact: true,
    hideOnMacOs: true,
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
      moveMacOs => null,
      delete => Assets.icons.interface.outline.trash,
      deleteMacOs => Assets.icons.interface.outline.trash,
      deletePermanently => Assets.icons.interface.outline.trash01,
      deletePermanentlyMacOs => Assets.icons.interface.outline.trash01,
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
      moveMacOs => 'Move',
      delete => 'Delete',
      deleteMacOs => 'Delete',
      deletePermanently => 'Delete permanently',
      deletePermanentlyMacOs => 'Delete permanently',
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

  static Iterable<EntityContextAction> getAvailableActions({
    bool isPressedAltOption = false,
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  }) {
    return EntityContextAction.values.where(
      (item) {
        if (!item.enabled) {
          return false;
        }

        if (item.showOnKeyHold != null &&
            isPressedAltOption == false &&
            isPressedShift == false &&
            isPressedControlCommand == false) {
          return false;
        }

        if (item.hideOnKeyHold != null &&
            isPressedAltOption &&
            item.hideOnKeyHold == LogicalKeyboardKey.alt) {
          return false;
        }

        if (item.hideOnKeyHold != null &&
            isPressedShift &&
            item.hideOnKeyHold == LogicalKeyboardKey.shift) {
          return false;
        }

        if (item.hideOnKeyHold != null &&
            isPressedControlCommand &&
            (item.hideOnKeyHold == LogicalKeyboardKey.control ||
                item.hideOnKeyHold == LogicalKeyboardKey.meta)) {
          return false;
        }

        if (item.showOnKeyHold != null &&
            !isPressedAltOption &&
            item.showOnKeyHold == LogicalKeyboardKey.alt) {
          return false;
        }

        if (item.showOnKeyHold != null &&
            !isPressedShift &&
            item.showOnKeyHold == LogicalKeyboardKey.shift) {
          return false;
        }

        if (item.showOnKeyHold != null &&
            !isPressedControlCommand &&
            (item.showOnKeyHold == LogicalKeyboardKey.control ||
                item.showOnKeyHold == LogicalKeyboardKey.meta)) {
          return false;
        }

        return true;
      },
    );
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
