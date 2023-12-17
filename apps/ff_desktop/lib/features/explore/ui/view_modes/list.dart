part of '../entity_view.dart';

class EntityViewList extends StatelessWidget {
  static ViewMode mode = ViewMode.list;

  final ScrollController scrollController;
  final List<Entity> entities;
  final Set<Entity> Function() selectedEntitiesGetter;
  final Set<Entity> Function() copiedEntitiesGetter;

  final ValueChanged<Set<Entity>> onSelectionChanged;
  final ValueChanged<Entity> onEntityTap;
  final ValueChanged<Entity> onEntityDoubleTap;

  final Function(EntityContextAction action)? onAction;

  const EntityViewList({
    super.key,
    required this.entities,
    required this.selectedEntitiesGetter,
    required this.copiedEntitiesGetter,
    required this.scrollController,
    required this.onSelectionChanged,
    required this.onEntityTap,
    required this.onEntityDoubleTap,
    required this.onAction,
  });

  List<int> _getSelectedIndexesWithinBounds(Rect rect, int maxItemsPerColumn) {
    final selectedIndexes = <int>[];
    final itemWidth = mode.itemWidth;
    final itemHeight = mode.itemHeight;

    final scrollOffset = scrollController.offset;
    if (scrollOffset > 0) {
      rect = rect.translate(scrollOffset, 0);
    }

    for (var i = 0; i < entities.length; i++) {
      final entityX = (i ~/ maxItemsPerColumn) * itemWidth;
      final entityY = (i % maxItemsPerColumn) * itemHeight;
      final entityRect = Rect.fromLTWH(
        entityX,
        entityY,
        itemWidth,
        itemHeight,
      );

      if (rect.overlaps(entityRect)) {
        selectedIndexes.add(i);
      }
    }
    return selectedIndexes;
  }

  void _updateSelectedIndexes(Rect rect, int maxItemsPerColumn) {
    final selectedIndexes = _getSelectedIndexesWithinBounds(
      rect,
      maxItemsPerColumn,
    );
    final selectedEntities = selectedIndexes.map((index) {
      return entities[index];
    }).toSet();

    onSelectionChanged(selectedEntities);
  }

  @override
  Widget build(BuildContext context) {
    final bound = context.findRenderObject()?.paintBounds;
    final containerHeight = (bound?.height ?? 0) - Spacing.d24;
    final maxItemsPerColumn = max(
      1,
      (containerHeight / mode.itemHeight).floor(),
    );
    final backgroundColor = context.appTheme.color.background;
    final selectedBackgroundColor =
        context.appTheme.color.primary.withOpacity(0.2);
    final appTheme = context.appTheme;

    final selectedEntities = selectedEntitiesGetter.call();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SelectRectangleOverlay(
        scrollController: scrollController,
        onDragStart: (position) {},
        onRectangleUpdated: (rect) {
          _updateSelectedIndexes(rect, maxItemsPerColumn);
        },
        onDragUpdate: (position) {},
        onDragEnd: () {},
        onReachedBorder: (borders) {
          final maxScrollPosition = scrollController.position.maxScrollExtent;
          if (borders.contains(BorderType.right)) {
            final newPosition = scrollController.offset + mode.itemWidth;
            scrollController.animateTo(
              min(newPosition, maxScrollPosition),
              curve: Curves.linear,
              duration: FludaDuration.ms2,
            );
          } else if (borders.contains(BorderType.left)) {
            final newPosition = scrollController.offset - mode.itemWidth;
            scrollController.animateTo(
              max(newPosition, 0),
              curve: Curves.linear,
              duration: FludaDuration.ms2,
            );
          }
        },
        child: CommonEntityActionsWrapper(
          selectedEntitiesGetter: selectedEntitiesGetter,
          copiedEntitiesGetter: copiedEntitiesGetter,
          onAction: onAction,
          child: GridView.builder(
            padding: EdgeInsets.only(
              top: Spacing.d8,
              bottom: Spacing.d16,
            ),
            controller: scrollController,
            itemCount: entities.length,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: mode.itemWidth,
              crossAxisCount: maxItemsPerColumn,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: mode.itemHeight / mode.itemWidth,
            ),
            itemBuilder: (BuildContext context, int index) {
              final entity = entities[index];
              final isSelected = selectedEntities.contains(entity);
              return Container(
                key: ValueKey(entity.path.toFilePath()),
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d8,
                ),
                child: Listener(
                  onPointerDown: (event) {
                    if (isSelected && event.buttons != kPrimaryMouseButton) {
                      return;
                    }
                    onEntityTap(entity);
                  },
                  child: ListItem(
                    mouseCursor: SystemMouseCursors.basic,
                    height: mode.itemHeight - Spacing.d4,
                    backgroundColor:
                        isSelected ? selectedBackgroundColor : backgroundColor,
                    onDoubleTap: () => onEntityDoubleTap(entity),
                    enableAnimation: false,
                    leading: EntityIconWidget(
                      entity: entity,
                      size: Spacing.d20,
                    ),
                    titlePadding: EdgeInsets.only(
                      left: Spacing.d8,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.d8,
                      vertical: Spacing.d4,
                    ),
                    hoverOverlayPadding: EdgeInsets.only(
                      bottom: Spacing.d4,
                    ),
                    title: Text(
                      entity.name,
                      style: TextStyle(
                        color: entity.isHidden
                            ? appTheme.color.disabledIconColor
                            : appTheme.color.onBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
