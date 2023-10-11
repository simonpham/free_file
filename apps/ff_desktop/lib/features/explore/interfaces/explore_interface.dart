import 'dart:async';

import 'package:core/core.dart';

abstract interface class ExploreInterfaceManipulateActions {
  List<Entity> get copiedEntities;

  List<Entity> get cutEntities;

  void copy(Entity entity);

  void cut(Entity entity);

  void paste(Uri path);

  void delete(Entity entity);

  void rename(Entity entity, String name);

  Future<Entity> createFile(Uri path, String name);

  Future<Entity> createDirectory(Uri path, String name);
}

abstract interface class ExploreInterfaceSelectActions {
  List<Entity> get selectedEntities;

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
