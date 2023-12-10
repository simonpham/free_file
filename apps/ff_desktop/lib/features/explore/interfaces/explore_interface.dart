import 'dart:async';

import 'package:core/core.dart';

abstract interface class ExploreInterfaceManipulateActions {
  FutureOr<void> delete({Entity? entity});

  FutureOr<void> rename({Entity? entity, required String name});

  Future<Entity> createFile({Uri? path, required String name});

  Future<Entity> createDirectory({Uri? path, required String name});
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

  bool get isExpandable;

  Future<void> toggle();
}
