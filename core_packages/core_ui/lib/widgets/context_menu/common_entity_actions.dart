import 'package:core/core.dart';
import 'package:core_ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/models/entities/entities.dart';
import 'package:theme/models/models.dart';
import 'package:utils/constants/constants.dart';

enum EntityContextAction {
  open,
  openInNewWindow(supportedEntityTypes: [EntityType.directory]),
  openInNewTab(supportedEntityTypes: [EntityType.directory]),
  quickLook,
  compress,
  copy(isCompact: true),
  paste(isCompact: true),
  move(isCompact: true),
  delete(isCompact: true),
  deletePermanently(isCompact: true),
  rename(isCompact: true),
  properties,
  unknown;

  final bool isCompact;

  final List<EntityType> supportedEntityTypes;

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
    this.supportedEntityTypes = EntityType.values,
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
      paste => null,
      move => null,
      delete => Assets.icons.interface.outline.trash,
      deletePermanently => Assets.icons.interface.outline.trash01,
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
      paste => 'Paste',
      move => 'Move',
      delete => 'Delete',
      deletePermanently => 'Delete permanently',
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

  static Iterable<EntityContextAction> getAvailableActions({
    required Set<Entity> selectedEntities,
    bool isPressedAltOption = false,
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  }) {
    return EntityContextAction.values.where(
      (item) {
        if (item == unknown) {
          return false;
        }

        for (final entity in selectedEntities) {
          final entityType = entity.type;
          if (!item.supportedEntityTypes.contains(entityType)) {
            return false;
          }
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
