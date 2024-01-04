enum SideBarSection {
  home,
  pinned,
  cloud,
  yours,
  drives,
  tags,
}

enum PredefinedFolder {
  home,
  desktop,
  downloads,
  documents,
  pictures,
  videos,
  movies,
  music,
  trash,
}

enum ViewMode {
  list(
    itemWidth: 256.0,
    itemHeight: 41,
  ),
  details(
    itemWidth: double.infinity,
    itemHeight: 41,
  ),
  grid(
    itemWidth: 64.0,
    itemHeight: 64.0,
  ),
  columns(
    itemWidth: 256.0,
    itemHeight: 41,
  );

  final double itemHeight;
  final double itemWidth;

  const ViewMode({
    required this.itemHeight,
    required this.itemWidth,
  });
}
