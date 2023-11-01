import 'dart:async';

import 'package:core/core.dart';

abstract interface class ExploreInterfaceManipulateActions {
  Set<Entity> get copiedEntities;

  Set<Entity> get cutEntities;

  void copy(Entity entity);

  void cut(Entity entity);

  void paste(Uri path);

  void delete(Entity entity);

  void rename(Entity entity, String name);

  Future<Entity> createFile(Uri path, String name);

  Future<Entity> createDirectory(Uri path, String name);
}

abstract interface class ExploreInterfaceSelectActions {
  /// Select mode persists selected entities between refreshes and navigation.
  bool get isSelectModeEnabled;

  Set<Entity> get selectedEntities;

  void selectBatch(Set<Entity> entities);

  void select(Entity entity);

  void unselect(Entity entity);
}

abstract interface class ExploreInterface {
  Future<void> refresh();

  Uri get currentUri;

  List<Entity> get entities;

  void goTo(Uri uri);

  bool get canBack;

  void back();

  bool get canForward;

  void forward();

  bool get canUp;

  void up();
}

abstract interface class TreeExploreInterface {
  Directory get directory;

  List<TreeExploreInterface> get directories;

  List<File> get files;

  bool get isExpanded;

  Future<void> toggle();
}
