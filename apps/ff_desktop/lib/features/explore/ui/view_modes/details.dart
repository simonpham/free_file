part of '../entity_view.dart';

class EntityViewDetails extends StatelessWidget {
  static ViewMode mode = ViewMode.details;

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

  const EntityViewDetails({
    super.key,
    required this.entities,
    required this.currentUriGetter,
    required this.selectedEntitiesGetter,
    required this.copiedEntitiesGetter,
    required this.scrollController,
    required this.isRenaming,
    required this.entityNameFocusNode,
    required this.entityNameController,
    required this.onRenameFinished,
    required this.onSelectionChanged,
    required this.onEntityTap,
    required this.onEntityDoubleTap,
    required this.onAction,
  });

  List<int> _getSelectedIndexesWithinBounds(Rect rect) {
    final selectedIndexes = <int>[];
    final itemHeight = mode.itemHeight;

    for (var i = 0; i < entities.length; i++) {
      final entityY = i * itemHeight + Spacing.d8;
      final entityRect = Rect.fromLTWH(0, entityY, double.infinity, itemHeight);

      if (rect.overlaps(entityRect)) {
        selectedIndexes.add(i);
      }
    }
    return selectedIndexes;
  }

  void _updateSelectedIndexes(Rect rect) {
    final selectedIndexes = _getSelectedIndexesWithinBounds(rect);
    final selectedEntities = selectedIndexes.map((index) {
      return entities[index];
    }).toSet();

    onSelectionChanged(selectedEntities);
  }

  String _getKind(Entity entity) {
    if (entity.type == EntityType.directory) {
      return 'Folder';
    }

    final fileExtension = switch (entity) {
      File file => file.fileType.extension.toUpperCase(),
      _ => null,
    };

    if (fileExtension == null || fileExtension.isEmpty) {
      return 'Document';
    }

    return '$fileExtension File';
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.appTheme.color.background;
    final selectedBackgroundColor = context.appTheme.color.primary.withOpacity(
      0.2,
    );
    final appTheme = context.appTheme;
    final selectedEntities = selectedEntitiesGetter.call();
    final secondaryTextColor = appTheme.color.onBackground.withOpacity(0.5);
    final headerStyle = context.theme.textTheme.bodySmall?.copyWith(
      color: secondaryTextColor,
      fontWeight: FontWeight.w600,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SelectRectangleOverlay(
            scrollController: scrollController,
            onDragStart: (position) {},
            onRectangleUpdated: (rect) {
              if (rect.width < kSelectRectangleMinimumThreshold ||
                  rect.height < kSelectRectangleMinimumThreshold) {
                return;
              }
              _updateSelectedIndexes(rect);
            },
            onDragUpdate: (position) {},
            onDragEnd: () {},
            onReachedBorder: (borders) {
              final maxScrollPosition =
                  scrollController.position.maxScrollExtent;
              if (borders.contains(BorderType.bottom)) {
                final newPosition = scrollController.offset + mode.itemHeight;
                scrollController.animateTo(
                  min(newPosition, maxScrollPosition),
                  curve: Curves.linear,
                  duration: FludaDuration.ms2,
                );
              } else if (borders.contains(BorderType.top)) {
                final newPosition = scrollController.offset - mode.itemHeight;
                scrollController.animateTo(
                  max(newPosition, 0),
                  curve: Curves.linear,
                  duration: FludaDuration.ms2,
                );
              }
            },
            child: CommonEntityActionsWrapper(
              currentUriGetter: currentUriGetter,
              selectedEntitiesGetter: selectedEntitiesGetter,
              copiedEntitiesGetter: copiedEntitiesGetter,
              pinnedUrisGetter: () => Settings().pinnedUris,
              onAction: onAction,
              child: Column(
                children: [
                  // Header row
                  Container(
                    height: Spacing.d32,
                    padding: EdgeInsets.symmetric(horizontal: Spacing.d16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: secondaryTextColor.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: Spacing.d28, child: Container()),
                        Expanded(
                          flex: 4,
                          child: Text('Name', style: headerStyle),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Date Modified', style: headerStyle),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Kind', style: headerStyle),
                        ),
                      ],
                    ),
                  ),
                  // Data rows
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        top: Spacing.d4,
                        bottom: Spacing.d16,
                      ),
                      controller: scrollController,
                      itemCount: entities.length,
                      separatorBuilder: (_, _) => SizedBox(height: Spacing.d4),
                      itemBuilder: (BuildContext context, int index) {
                        final Entity entity = entities[index];
                        final isSelected = selectedEntities.contains(entity);
                        final shouldEnableNameEdit =
                            isRenaming &&
                            selectedEntities.isNotEmpty &&
                            selectedEntities.firstOrNull?.path.toRealPath() ==
                                entity.path.toRealPath();

                        return Container(
                          key: ValueKey(entity.path.toRealPath()),
                          padding: EdgeInsets.symmetric(horizontal: Spacing.d8),
                          child: Listener(
                            onPointerDown: (event) {
                              if (isSelected &&
                                  event.buttons != kPrimaryMouseButton) {
                                return;
                              }
                              onEntityTap(entity);
                            },
                            child: Tappable(
                              enableAnimation: false,
                              enableHover: true,
                              enableHoverOverlay: true,
                              hoverOverlayPadding: EdgeInsets.zero,
                              hoverOverlayBorderRadius: Spacing.d4,
                              mouseCursor: SystemMouseCursors.basic,
                              behavior: HitTestBehavior.translucent,
                              onDoubleTap: () => onEntityDoubleTap(entity),
                              child: Container(
                                height: mode.itemHeight,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? selectedBackgroundColor
                                      : backgroundColor,
                                  borderRadius: BorderRadius.circular(
                                    Spacing.d4,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: Spacing.d8,
                                  vertical: Spacing.d4,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Spacing.d16,
                                      child: EntityIconWidget(
                                        entity: entity,
                                        size: Spacing.d16,
                                      ),
                                    ),
                                    SizedBox(width: Spacing.d8),
                                    Expanded(
                                      flex: 4,
                                      child: shouldEnableNameEdit
                                          ? TextField(
                                              enabled: true,
                                              readOnly: false,
                                              focusNode: entityNameFocusNode,
                                              controller: entityNameController,
                                              onEditingComplete: () =>
                                                  onRenameFinished(),
                                              onTapOutside: (_) =>
                                                  onRenameFinished(),
                                              style: context
                                                  .theme
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        entity
                                                            .hiddenStatus
                                                            .isHidden
                                                        ? appTheme
                                                              .color
                                                              .disabledIconColor
                                                        : appTheme
                                                              .color
                                                              .onBackground,
                                                  ),
                                              maxLines: 1,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            )
                                          : Text(
                                              entity.name,
                                              style: context
                                                  .theme
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color:
                                                        entity
                                                            .hiddenStatus
                                                            .isHidden
                                                        ? appTheme
                                                              .color
                                                              .disabledIconColor
                                                        : appTheme
                                                              .color
                                                              .onBackground,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _formatDate(entity.updatedAt),
                                        style: context.theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _getKind(entity),
                                        style: context.theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
