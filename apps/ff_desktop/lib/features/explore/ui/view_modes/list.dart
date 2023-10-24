part of '../entity_view.dart';

const double _itemHeight = 41.0;
const double _itemWidth = 256.0;

class EntityViewList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Entity> entities;

  const EntityViewList({
    super.key,
    required this.entities,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.sizeOf(context).height;
    final maxItemsPerColumn = (containerHeight / _itemHeight).floor();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SelectRectangleOverlay(
        scrollController: scrollController,
        onDragStart: (position) {},
        onDragUpdate: (position) {},
        onDragEnd: () {},
        onReachedBorder: (borders) {
          final maxScrollPosition = scrollController.position.maxScrollExtent;
          if (borders.contains(BorderType.right)) {
            final newPosition = scrollController.offset + _itemWidth;
            scrollController.animateTo(
              min(newPosition, maxScrollPosition),
              curve: Curves.linear,
              duration: FludaDuration.ms2,
            );
          } else if (borders.contains(BorderType.left)) {
            final newPosition = scrollController.offset - _itemWidth;
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
            crossAxisCount: maxItemsPerColumn,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: _itemHeight / _itemWidth,
          ),
          itemBuilder: (BuildContext context, int index) {
            final entity = entities[index];
            return Container(
              key: ValueKey(entity.path.toFilePath()),
              height: _itemHeight,
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.d8,
              ),
              child: ListItem(
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
