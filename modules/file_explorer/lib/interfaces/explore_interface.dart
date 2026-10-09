import 'dart:async';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';

abstract interface class ExploreInterfaceManipulateActions {
  FutureOr<void> delete({Set<Entity>? entities});

  FutureOr<void> deletePermanently({Set<Entity>? entities});

  FutureOr<void> startRename();

  FutureOr<void> finishRename({Set<Entity>? entities, required String newName});

  void abortRename();

  Future<Entity> createFile({Uri? path, required String name});

  Future<Entity> createDirectory({Uri? path, required String name});
}

abstract interface class ExploreInterfaceSelectActions {
  /// Select mode persists selected entities between refreshes and navigation.
  bool get isSelectModeEnabled;

  Set<Entity> get selectedEntities;

  void selectBatch(Set<Entity> entities);

  void select(
    Entity entity, {
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  });

  void unselect(Entity entity);
}

abstract interface class ExploreInterface {
  Future<void> refresh({bool maintainState = false});

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
  SvgGenImage? get customIcon;

  SvgGenImage? get customSelectedIcon;

  Directory get directory;

  List<TreeExploreInterface> get directories;

  List<File> get files;

  bool get isExpanded;

  bool get isExpandable;

  Future<void> toggle();
}
