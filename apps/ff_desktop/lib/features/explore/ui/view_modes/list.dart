part of '../entity_view.dart';

class EntityViewList extends StatelessWidget {
  static ViewMode mode = ViewMode.list;

  final ScrollController scrollController;
  final List<Entity> entities;
  final Set<Entity> selectedEntities;

  final ValueChanged<Set<Entity>> onSelectionChanged;
  final ValueChanged<Entity> onEntityTap;
  final ValueChanged<Entity> onEntityDoubleTap;

  const EntityViewList({
    super.key,
    required this.entities,
    required this.selectedEntities,
    required this.scrollController,
    required this.onSelectionChanged,
    required this.onEntityTap,
    required this.onEntityDoubleTap,
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
            return GestureDetector(
              onTapDown: (event) {
                onEntityTap(entity);
              },
              child: Container(
                key: ValueKey(entity.path.toFilePath()),
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d8,
                ),
                child: ListItem(
                  height: mode.itemHeight - Spacing.d4,
                  backgroundColor: selectedEntities.contains(entity)
                      ? context.appTheme.color.primary.withOpacity(0.2)
                      : context.appTheme.color.background,
                  onDoubleTap: () => onEntityDoubleTap(entity),
                  enableAnimation: false,
                  leading: ImageView(
                    entity.entityIcon,
                    color: entity.getEntityColor(context),
                    size: Spacing.d20,
                  ),
                  titlePadding: EdgeInsets.only(
                    left: Spacing.d8,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.d8,
                    vertical: Spacing.d4,
                  ),
                  title: Text(
                    entity.name,
                    style: TextStyle(
                      color: entity.isHidden
                          ? context.appTheme.color.disabledIconColor
                          : context.appTheme.color.onBackground,
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
    );
  }
}
