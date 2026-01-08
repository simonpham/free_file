part of '../entity_view.dart';

class EntityViewDetails extends StatefulWidget {
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

  final DetailsSortColumn sortColumn;
  final SortDirection sortDirection;
  final ValueChanged<DetailsSortColumn> onSortChanged;

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
    required this.sortColumn,
    required this.sortDirection,
    required this.onSortChanged,
  });

  @override
  State<EntityViewDetails> createState() => _EntityViewDetailsState();
}

class _EntityViewDetailsState extends State<EntityViewDetails> {
  late PaneController _paneController;

  static const _kIconColumnId = 'icon';
  static const _kNameColumnId = 'name';
  static const _kDateColumnId = 'date';
  static const _kKindColumnId = 'kind';

  @override
  void initState() {
    super.initState();
    _paneController = PaneController(
      entries: [
        PaneEntry(
          id: _kIconColumnId,
          initialSize: PaneSize.pixel(28),
          minSize: PaneSize.pixel(28),
          maxSize: PaneSize.pixel(28),
        ),
        PaneEntry(
          id: _kNameColumnId,
          initialSize: PaneSize.fraction(0.5),
          minSize: PaneSize.pixel(100),
        ),
        PaneEntry(
          id: _kDateColumnId,
          initialSize: PaneSize.fraction(0.25),
          minSize: PaneSize.pixel(80),
        ),
        PaneEntry(
          id: _kKindColumnId,
          initialSize: PaneSize.fraction(0.25),
          minSize: PaneSize.pixel(80),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _paneController.dispose();
    super.dispose();
  }

  List<int> _getSelectedIndexesWithinBounds(Rect rect) {
    final selectedIndexes = <int>[];
    final itemHeight = EntityViewDetails.mode.itemHeight;

    for (var i = 0; i < widget.entities.length; i++) {
      final entityY = Spacing.d4 + i * (itemHeight + Spacing.d4);
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
      return widget.entities[index];
    }).toSet();

    widget.onSelectionChanged(selectedEntities);
  }

  String _getKind(Entity entity) {
    if (entity.type == EntityType.directory) {
      return context.localize.kindFolder;
    }

    final fileExtension = switch (entity) {
      File file => file.fileType.extension.toUpperCase(),
      _ => null,
    };

    if (fileExtension == null || fileExtension.isEmpty) {
      return context.localize.kindDocument;
    }

    return context.localize.kindFile(fileExtension);
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

  Widget _buildSortableHeader({
    required String label,
    required DetailsSortColumn column,
    required TextStyle? style,
  }) {
    final isActive = widget.sortColumn == column;
    final iconColor = style?.color ?? Colors.grey;

    return Tappable(
      onTap: () => widget.onSortChanged(column),
      enableAnimation: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.d8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: style)),
              if (isActive) ...[
                SizedBox(width: Spacing.d4),
                ImageView(
                  switch (widget.sortDirection) {
                    SortDirection.ascending =>
                      Assets.icons.interface.outline.sortArrowUp,
                    SortDirection.descending =>
                      Assets.icons.interface.outline.sortArrowDown,
                  },
                  size: Spacing.d12,
                  color: iconColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.appTheme.color.background;
    final selectedBackgroundColor = context.appTheme.color.primary.withValues(
      alpha: 0.2,
    );
    final appTheme = context.appTheme;
    final selectedEntities = widget.selectedEntitiesGetter.call();
    final secondaryTextColor = appTheme.color.onBackground.withValues(
      alpha: 0.5,
    );
    final headerStyle = context.theme.textTheme.bodySmall?.copyWith(
      color: secondaryTextColor,
      fontWeight: FontWeight.w600,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: widget.scrollController,
          thumbVisibility: true,
          child: CommonEntityActionsWrapper(
            currentUriGetter: widget.currentUriGetter,
            selectedEntitiesGetter: widget.selectedEntitiesGetter,
            copiedEntitiesGetter: widget.copiedEntitiesGetter,
            pinnedUrisGetter: () => Settings().pinnedUris,
            onAction: widget.onAction,
            child: Column(
              children: [
                // Header row with resizable columns.
                Container(
                  height: Spacing.d32,
                  padding: EdgeInsets.symmetric(horizontal: Spacing.d16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: secondaryTextColor.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: PaneTheme(
                    data: PaneThemeData(
                      resizerColor: appTheme.color.disabledIconColor,
                      resizerThickness: 1.0,
                      resizerHitTestThickness: 4.0,
                      resizerFocusedColor: appTheme.color.primary,
                      resizerHoverColor: appTheme.color.primary,
                    ),
                    child: MultiPane(
                      controller: _paneController,
                      direction: Axis.horizontal,
                      paneBuilder: (context, id) => switch (id) {
                        _kIconColumnId => const SizedBox(),
                        _kNameColumnId => _buildSortableHeader(
                          label: context.localize.headerName,
                          column: DetailsSortColumn.name,
                          style: headerStyle,
                        ),
                        _kDateColumnId => _buildSortableHeader(
                          label: context.localize.headerDateModified,
                          column: DetailsSortColumn.dateModified,
                          style: headerStyle,
                        ),
                        _kKindColumnId => _buildSortableHeader(
                          label: context.localize.headerKind,
                          column: DetailsSortColumn.kind,
                          style: headerStyle,
                        ),
                        _ => const SizedBox(),
                      },
                    ),
                  ),
                ),
                // Data rows.
                Expanded(
                  child: SelectRectangleOverlay(
                    scrollController: widget.scrollController,
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
                          widget.scrollController.position.maxScrollExtent;
                      if (borders.contains(BorderType.bottom)) {
                        final newPosition =
                            widget.scrollController.offset +
                            EntityViewDetails.mode.itemHeight;
                        widget.scrollController.animateTo(
                          min(newPosition, maxScrollPosition),
                          curve: Curves.linear,
                          duration: FludaDuration.ms2,
                        );
                      } else if (borders.contains(BorderType.top)) {
                        final newPosition =
                            widget.scrollController.offset -
                            EntityViewDetails.mode.itemHeight;
                        widget.scrollController.animateTo(
                          max(newPosition, 0),
                          curve: Curves.linear,
                          duration: FludaDuration.ms2,
                        );
                      }
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        top: Spacing.d4,
                        bottom: Spacing.d16,
                      ),
                      controller: widget.scrollController,
                      itemCount: widget.entities.length,
                      separatorBuilder: (_, _) => SizedBox(height: Spacing.d4),
                      itemBuilder: (BuildContext context, int index) {
                        final Entity entity = widget.entities[index];
                        final isSelected = selectedEntities.contains(entity);
                        final shouldEnableNameEdit =
                            widget.isRenaming &&
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
                              widget.onEntityTap(entity);
                            },
                            child: DraggableWraper(
                              entity: entity,
                              child: Tappable(
                                enableAnimation: false,
                                enableHover: true,
                                enableHoverOverlay: true,
                                hoverOverlayPadding: EdgeInsets.zero,
                                hoverOverlayBorderRadius: Spacing.d4,
                                mouseCursor: SystemMouseCursors.basic,
                                behavior: HitTestBehavior.translucent,
                                onDoubleTap: () =>
                                    widget.onEntityDoubleTap(entity),
                                child: Container(
                                  height: EntityViewDetails.mode.itemHeight,
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
                                  child: PaneTheme(
                                    data: const PaneThemeData(
                                      resizerColor: Colors.transparent,
                                    ),
                                    child: MultiPane(
                                      controller: _paneController,
                                      direction: Axis.horizontal,
                                      paneBuilder: (context, id) => switch (id) {
                                        _kIconColumnId => Center(
                                          child: EntityIconWidget(
                                            entity: entity,
                                            size: Spacing.d24,
                                          ),
                                        ),
                                        _kNameColumnId =>
                                          shouldEnableNameEdit
                                              ? TextField(
                                                  enabled: true,
                                                  readOnly: false,
                                                  focusNode: widget
                                                      .entityNameFocusNode,
                                                  controller: widget
                                                      .entityNameController,
                                                  onEditingComplete: () =>
                                                      widget.onRenameFinished(),
                                                  onTapOutside: (_) =>
                                                      widget.onRenameFinished(),
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
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                      ),
                                                )
                                              : Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                        _kDateColumnId => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _formatDate(entity.updatedAt),
                                            style: context
                                                .theme
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: secondaryTextColor,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        _kKindColumnId => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _getKind(entity),
                                            style: context
                                                .theme
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: secondaryTextColor,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        _ => const SizedBox(),
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
