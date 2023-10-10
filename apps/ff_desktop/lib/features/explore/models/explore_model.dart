import 'dart:async';

import 'package:core/core.dart';
import 'package:ff_desktop/di.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

import 'package:ff_desktop/features/explore/explore.dart';
import 'package:utils/constants/constants.dart';

class ExploreViewModel extends ChangeNotifier
    implements
        ExploreInterface,
        ExploreInterfaceSelectActions,
        ExploreInterfaceManipulateActions {
  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  ExploreViewModel() {
    goTo(_currentUri);
  }

  Uri _currentUri = Uri.parse(kSlash);
  List<Entity> _entities = [];
  List<Entity> _selectedEntities = [];
  List<Entity> _copiedEntities = [];
  List<Entity> _cutEntities = [];

  @override
  Uri get currentUri => _currentUri;

  @override
  List<Entity> get entities => _entities;

  @override
  List<Entity> get selectedEntities => _selectedEntities;

  @override
  List<Entity> get copiedEntities => _copiedEntities;

  @override
  List<Entity> get cutEntities => _cutEntities;

  @override
  void goTo(Uri uri) {
    _local.list(uri).then((entities) {
      _entities.clear();
      _entities = entities;
      _currentUri = uri;
      notifyListeners();
    });
  }

  @override
  void copy(Entity entity) {
    // TODO: implement copy
  }

  @override
  Future<Entity> createDirectory(Uri path, String name) {
    // TODO: implement createDirectory
    throw UnimplementedError();
  }

  @override
  Future<Entity> createFile(Uri path, String name) {
    // TODO: implement createFile
    throw UnimplementedError();
  }

  @override
  void cut(Entity entity) {
    // TODO: implement cut
  }

  @override
  void delete(Entity entity) {
    // TODO: implement delete
  }

  @override
  void paste(Uri path) {
    // TODO: implement paste
  }

  @override
  void rename(Entity entity, String name) {
    // TODO: implement rename
  }

  @override
  void select(Entity entity) {
    // TODO: implement select
  }

  @override
  void unselect(Entity entity) {
    // TODO: implement unselect
  }
}
