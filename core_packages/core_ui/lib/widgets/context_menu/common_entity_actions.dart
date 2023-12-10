import 'package:core_ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/models/entities/entities.dart';
import 'package:theme/models/models.dart';
import 'package:utils/constants/constants.dart';

enum EntityContextAction {
  open,
  openInNewWindow,
  openInNewTab,
  quickLook,
  compress,
  copyMacOs(isMacOsOnly: true, isCompact: true),
  copy(isCompact: true, hideOnMacOs: true),
  paste(isCompact: true, hideOnMacOs: true),
  pasteMacOs(isCompact: true, isMacOsOnly: true),
  moveMacOs(isCompact: true, isMacOsOnly: true),
  move(isCompact: true, hideOnMacOs: true),
  delete(isCompact: true, hideOnMacOs: true),
  deleteMacOs(isCompact: true, isMacOsOnly: true),
  deletePermanentlyMacOs(isCompact: true, isMacOsOnly: true),
  deletePermanently(isCompact: true, hideOnMacOs: true),
  rename(isCompact: true),
  properties,
  unknown;

  final bool isCompact;
  final bool isMacOsOnly;
  final bool hideOnMacOs;

  List<LogicalKeyboardKey> get shortcutKey {
    return ThemeConfigs().shortcut.items[name]?.shortcutKey ?? const [];
  }

  LogicalKeySet? get keySet {
    final shortcutKey = this.shortcutKey;
    if (shortcutKey.isEmpty) {
      return null;
    }

    return LogicalKeySet.fromSet(
      shortcutKey.toSet(),
    );
  }

  LogicalKeyboardKey? get showOnKeyHold {
    return ThemeConfigs().shortcut.items[name]?.showOnKeyHold;
  }

  LogicalKeyboardKey? get hideOnKeyHold {
    return ThemeConfigs().shortcut.items[name]?.hideOnKeyHold;
  }

  const EntityContextAction({
    this.isCompact = false,
    this.isMacOsOnly = false,
    this.hideOnMacOs = false,
  });

  factory EntityContextAction.parse(String value) {
    return EntityContextAction.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EntityContextAction.unknown,
    );
  }

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
      unknown => null,
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
      unknown => 'Unknown',
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
