import 'package:core/core.dart';
import 'package:core_ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme/models/entities/entities.dart';
import 'package:theme/models/models.dart';
import 'package:utils/utils.dart';

enum EntityContextAction {
  open,
  openInNewWindow(
    supportedEntityTypes: [EntityType.directory],
    minSelectedEntities: 0,
  ),
  openInNewTab(
    supportedEntityTypes: [EntityType.directory],
    minSelectedEntities: 0,
  ),
  quickLook(minSelectedEntities: 0),
  compress,
  copy(isCompact: true),
  paste(isCompact: true, minSelectedEntities: 0),
  move(isCompact: false, minSelectedEntities: 0),
  delete(isCompact: true),
  deletePermanently(isCompact: false),
  rename(
    isCompact: true,
    minSelectedEntities: 1,
    maxSelectedEntities: 1,
  ),
  properties(minSelectedEntities: 0),
  selectAll(minSelectedEntities: 0),
  unknown;

  final bool isVisible;

  final bool isCompact;

  /// The minimum number of selected entities required to show this action.
  /// If the number of selected entities is less than this value, this action
  /// will not be shown.
  final int minSelectedEntities;

  /// The maximum number of selected entities required to show this action.
  /// If the number of selected entities is more than this value, this action
  /// will not be shown.
  /// If this value is null, there is no limit.
  final int? maxSelectedEntities;

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
    this.isVisible = true,
    this.minSelectedEntities = 1,
    this.maxSelectedEntities,
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
      paste => Assets.icons.filesAndFolder.outline.filePaste,
      move => null,
      delete => Assets.icons.interface.outline.trash,
      deletePermanently => Assets.icons.interface.outline.trash01,
      rename => Assets.icons.interface.outline.edit,
      properties => null,
      selectAll => null,
      unknown => null,
    };
  }

  String getLabel(
    BuildContext context,
    Set<Entity> selectedEntities,
    Set<Entity> copiedEntities,
  ) {
    final bool hasSelectedManyItems = selectedEntities.length > 1;
    final bool hasCopiedManyItems = copiedEntities.length > 1;
    return switch (this) {
      open => 'Open',
      openInNewWindow when hasSelectedManyItems => 'Open in new windows',
      openInNewWindow => 'Open in new window',
      openInNewTab when hasSelectedManyItems => 'Open in new tabs',
      openInNewTab => 'Open in new tab',
      quickLook => 'Quick look',
      compress => 'Compress',
      copy => 'Copy',
      paste when hasCopiedManyItems =>
        'Paste ${copiedEntities.length} items here',
      paste when copiedEntities.isEmpty => 'Paste',
      paste => 'Paste "${copiedEntities.first.name.truncateMiddlePath()}" here',
      move when hasCopiedManyItems =>
        'Move ${copiedEntities.length} items here',
      move when copiedEntities.isEmpty => 'Move',
      move => 'Move "${copiedEntities.first.name.truncateMiddlePath()}" here',
      delete => 'Delete',
      deletePermanently => 'Delete permanently',
      rename => 'Rename',
      properties => 'Properties',
      selectAll => 'Select all',
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
    required Set<Entity> copiedEntities,
    bool isPressedAltOption = false,
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  }) {
    return EntityContextAction.values.where(
      (item) {
        if (item == unknown || !item.isVisible) {
          return false;
        }

        if (item == openInNewWindow) {
          // Not supported yet.
          return false;
        }

        for (final entity in selectedEntities) {
          final entityType = entity.type;
          if (!item.supportedEntityTypes.contains(entityType)) {
            return false;
          }
        }

        if (item.minSelectedEntities > selectedEntities.length) {
          return false;
        }

        if (item.maxSelectedEntities != null &&
            item.maxSelectedEntities! < selectedEntities.length) {
          return false;
        }

        if ((item == paste || item == move) && copiedEntities.isEmpty) {
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
