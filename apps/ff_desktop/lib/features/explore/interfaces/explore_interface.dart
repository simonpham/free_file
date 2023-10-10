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
  StreamController<Uri> get pathController;

  StreamController<List<Entity>> get entitiesController;
}
