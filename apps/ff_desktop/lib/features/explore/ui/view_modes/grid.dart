part of '../entity_view.dart';

class EntityViewGrid extends StatelessWidget {
  static ViewMode mode = ViewMode.grid;

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

  const EntityViewGrid({
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

  List<int> _getSelectedIndexesWithinBounds(Rect rect, int maxItemsPerRow) {
    final selectedIndexes = <int>[];
    final itemWidth = mode.itemWidth;
    final itemHeight = mode.itemHeight;

    // rect is now in absolute content coordinates, no translation needed

    for (var i = 0; i < entities.length; i++) {
      final entityX = (i % maxItemsPerRow) * itemWidth;
      final entityY = (i ~/ maxItemsPerRow) * itemHeight;
      final entityRect = Rect.fromLTWH(entityX, entityY, itemWidth, itemHeight);

      if (rect.overlaps(entityRect)) {
        selectedIndexes.add(i);
      }
    }
    return selectedIndexes;
  }

  void _updateSelectedIndexes(Rect rect, int maxItemsPerRow) {
    final selectedIndexes = _getSelectedIndexesWithinBounds(
      rect,
      maxItemsPerRow,
    );
    final selectedEntities = selectedIndexes.map((index) {
      return entities[index];
    }).toSet();

    onSelectionChanged(selectedEntities);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.appTheme.color.background;
    final selectedBackgroundColor = context.appTheme.color.primary.withOpacity(
      0.2,
    );
    final appTheme = context.appTheme;
    final selectedEntities = selectedEntitiesGetter.call();

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth - Spacing.d24;
        final maxItemsPerRow = max(
          1,
          (containerWidth / mode.itemWidth).floor(),
        );

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

              _updateSelectedIndexes(rect, maxItemsPerRow);
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
              child: GridView.builder(
                padding: EdgeInsets.only(left: Spacing.d8, right: Spacing.d16),
                controller: scrollController,
                itemCount: entities.length,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: mode.itemHeight,
                  crossAxisCount: maxItemsPerRow,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: mode.itemWidth / mode.itemHeight,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Entity entity = entities[index];
                  final isSelected = selectedEntities.contains(entity);
                  final shouldEnableNameEdit =
                      isRenaming &&
                      selectedEntities.isNotEmpty &&
                      selectedEntities.firstOrNull?.path.toRealPath() ==
                          entity.path.toRealPath();
                  return SizedBox(
                    key: ValueKey(entity.path.toRealPath()),
                    width: mode.itemWidth,
                    height: mode.itemHeight,
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
                        hoverOverlayBorderRadius: Spacing.d8,
                        mouseCursor: SystemMouseCursors.basic,
                        behavior: HitTestBehavior.translucent,
                        onDoubleTap: () => onEntityDoubleTap(entity),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? selectedBackgroundColor
                                : backgroundColor,
                            borderRadius: BorderRadius.circular(Spacing.d8),
                          ),
                          padding: EdgeInsets.all(Spacing.d4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Spacing.d32,
                                height: Spacing.d32,
                                child: EntityIconWidget(
                                  entity: entity,
                                  size: Spacing.d32,
                                ),
                              ),
                              SizedBox(height: Spacing.d4),
                              Expanded(
                                child: shouldEnableNameEdit
                                    ? TextField(
                                        enabled: true,
                                        readOnly: false,
                                        focusNode: entityNameFocusNode,
                                        controller: entityNameController,
                                        onEditingComplete: () =>
                                            onRenameFinished(),
                                        onTapOutside: (_) => onRenameFinished(),
                                        style: context.theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  entity.hiddenStatus.isHidden
                                                  ? appTheme
                                                        .color
                                                        .disabledIconColor
                                                  : appTheme.color.onBackground,
                                              fontSize: 10,
                                            ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      )
                                    : Text(
                                        entity.name,
                                        style: context.theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color:
                                                  entity.hiddenStatus.isHidden
                                                  ? appTheme
                                                        .color
                                                        .disabledIconColor
                                                  : appTheme.color.onBackground,
                                              fontSize: 10,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
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
          ),
        );
      },
    );
  }
}
