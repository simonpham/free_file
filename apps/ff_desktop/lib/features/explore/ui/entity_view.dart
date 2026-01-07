import 'dart:math';
import 'dart:typed_data';

import 'package:ff_desktop/features/explore/explore.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:storage/storage.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:l10n/l10n.dart';

part 'view_modes/list.dart';
part 'view_modes/grid.dart';
part 'view_modes/details.dart';

class EntityView extends StatelessWidget {
  final ViewMode mode;
  final ScrollController scrollController;

  final List<Entity> entities;
  final Uri Function() currentUriGetter;
  final Set<Entity> Function() selectedEntitiesGetter;
  final Set<Entity> Function() copiedEntitiesGetter;

  final bool isRenaming;
  final FocusNode? entityNameFocusNode;
  final TextEditingController? entityNameController;
  final VoidCallback onRenameFinished;

  final ValueChanged<Set<Entity>> onSelectionChanged;
  final ValueChanged<Entity> onEntityTap;
  final ValueChanged<Entity> onEntityDoubleTap;

  final Function(EntityContextAction action)? onAction;

  final DetailsSortColumn sortColumn;
  final SortDirection sortDirection;
  final ValueChanged<DetailsSortColumn> onSortChanged;

  /// Called when files are dropped from external apps (e.g., Finder).
  final ValueChanged<List<Uri>>? onFilesDropped;

  /// Called when binary data is dropped (e.g., image from browser).
  final void Function(Uint8List data, String? suggestedName, String extension)?
      onDataDropped;

  /// Called when text is dropped from external apps.
  final ValueChanged<String>? onTextDropped;

  const EntityView({
    super.key,
    this.mode = ViewMode.list,
    required this.scrollController,
    required this.entities,
    required this.currentUriGetter,
    required this.selectedEntitiesGetter,
    required this.copiedEntitiesGetter,
    required this.isRenaming,
    required this.entityNameFocusNode,
    required this.entityNameController,
    required this.onRenameFinished,
    required this.onSelectionChanged,
    required this.onEntityTap,
    required this.onEntityDoubleTap,
    required this.onAction,
    required this.sortColumn,
    required this.sortDirection,
    required this.onSortChanged,
    this.onFilesDropped,
    this.onDataDropped,
    this.onTextDropped,
  });

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context); // rebuild on resize.
    
    final viewModeWidget = switch (mode) {
      ViewMode.list => EntityViewList(
        scrollController: scrollController,
        entities: entities,
        currentUriGetter: currentUriGetter,
        selectedEntitiesGetter: selectedEntitiesGetter,
        copiedEntitiesGetter: copiedEntitiesGetter,
        isRenaming: isRenaming,
        entityNameFocusNode: entityNameFocusNode,
        entityNameController: entityNameController,
        onRenameFinished: onRenameFinished,
        onSelectionChanged: onSelectionChanged,
        onEntityTap: onEntityTap,
        onEntityDoubleTap: onEntityDoubleTap,
        onAction: onAction,
      ),
      ViewMode.details => EntityViewDetails(
        scrollController: scrollController,
        entities: entities,
        currentUriGetter: currentUriGetter,
        selectedEntitiesGetter: selectedEntitiesGetter,
        copiedEntitiesGetter: copiedEntitiesGetter,
        isRenaming: isRenaming,
        entityNameFocusNode: entityNameFocusNode,
        entityNameController: entityNameController,
        onRenameFinished: onRenameFinished,
        onSelectionChanged: onSelectionChanged,
        onEntityTap: onEntityTap,
        onEntityDoubleTap: onEntityDoubleTap,
        onAction: onAction,
        sortColumn: sortColumn,
        sortDirection: sortDirection,
        onSortChanged: onSortChanged,
      ),
      ViewMode.grid => EntityViewGrid(
        scrollController: scrollController,
        entities: entities,
        currentUriGetter: currentUriGetter,
        selectedEntitiesGetter: selectedEntitiesGetter,
        copiedEntitiesGetter: copiedEntitiesGetter,
        isRenaming: isRenaming,
        entityNameFocusNode: entityNameFocusNode,
        entityNameController: entityNameController,
        onRenameFinished: onRenameFinished,
        onSelectionChanged: onSelectionChanged,
        onEntityTap: onEntityTap,
        onEntityDoubleTap: onEntityDoubleTap,
        onAction: onAction,
      ),
    };

    return DropRegionWrapper(
      onFilesDropped: onFilesDropped,
      onDataDropped: onDataDropped,
      onTextDropped: onTextDropped,
      child: viewModeWidget,
    );
  }
}

