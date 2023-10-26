part of '../entity_view.dart';

class EntityViewList extends StatefulWidget {
  static ViewMode mode = ViewMode.list;

  final ScrollController scrollController;
  final List<Entity> entities;

  const EntityViewList({
    super.key,
    required this.entities,
    required this.scrollController,
  });

  @override
  State<EntityViewList> createState() => _EntityViewListState();
}

class _EntityViewListState extends State<EntityViewList> {
  List<int> _selectedIndexes = [];

  List<int> _getSelectedIndexesWithinBounds(Rect rect, int maxItemsPerColumn) {
    final selectedIndexes = <int>[];
    final itemWidth = EntityViewList.mode.itemWidth;
    final itemHeight = EntityViewList.mode.itemHeight;

    final scrollOffset = widget.scrollController.offset;
    if (scrollOffset > 0) {
      rect = rect.translate(scrollOffset, 0);
    }

    for (var i = 0; i < widget.entities.length; i++) {
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
    _selectedIndexes = _getSelectedIndexesWithinBounds(rect, maxItemsPerColumn);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.sizeOf(context).height;
    final maxItemsPerColumn =
        (containerHeight / EntityViewList.mode.itemHeight).floor();
    return Scrollbar(
      controller: widget.scrollController,
      thumbVisibility: true,
      child: SelectRectangleOverlay(
        scrollController: widget.scrollController,
        onDragStart: (position) {},
        onRectangleUpdated: (rect) {
          _updateSelectedIndexes(rect, maxItemsPerColumn);
        },
        onDragUpdate: (position) {},
        onDragEnd: () {},
        onReachedBorder: (borders) {
          final maxScrollPosition =
              widget.scrollController.position.maxScrollExtent;
          if (borders.contains(BorderType.right)) {
            final newPosition =
                widget.scrollController.offset + EntityViewList.mode.itemWidth;
            widget.scrollController.animateTo(
              min(newPosition, maxScrollPosition),
              curve: Curves.linear,
              duration: FludaDuration.ms2,
            );
          } else if (borders.contains(BorderType.left)) {
            final newPosition =
                widget.scrollController.offset - EntityViewList.mode.itemWidth;
            widget.scrollController.animateTo(
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
          controller: widget.scrollController,
          itemCount: widget.entities.length,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxItemsPerColumn,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio:
                EntityViewList.mode.itemHeight / EntityViewList.mode.itemWidth,
          ),
          itemBuilder: (BuildContext context, int index) {
            final entity = widget.entities[index];
            return Container(
              key: ValueKey(entity.path.toFilePath()),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.d8,
              ),
              child: ListItem(
                backgroundColor: _selectedIndexes.contains(index)
                    ? context.appTheme.color.primary.withOpacity(0.2)
                    : context.appTheme.color.background,
                onDoubleTap: () => entity.doubleTap(context),
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
            );
          },
        ),
      ),
    );
  }
}
