import 'dart:async';

import 'package:core/core.dart';
import 'package:ff_desktop/di.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

import 'package:ff_desktop/features/explore/explore.dart';

class ExploreViewModel extends ChangeNotifier
    implements
        ExploreInterface,
        ExploreInterfaceSelectActions,
        ExploreInterfaceManipulateActions {
  EntityProvider get _local => injector.get<LocalEntityProvider>();

  StreamSubscription<Uri>? _pathSubscription;

  ExploreViewModel() {
    _pathSubscription = _pathController.stream.listen((path) async {
      final entities = await _local.list(path);
      _entitiesController.add(entities);
    });
  }

  @override
  void dispose() {
    _pathSubscription?.cancel();
    _pathSubscription = null;
    super.dispose();
  }

  final StreamController<Uri> _pathController =
      StreamController<Uri>.broadcast();
  final StreamController<List<Entity>> _entitiesController =
      StreamController<List<Entity>>.broadcast();

  final List<Entity> _selectedEntities = [];
  final List<Entity> _copiedEntities = [];
  final List<Entity> _cutEntities = [];

  @override
  StreamController<Uri> get pathController => _pathController;

  @override
  StreamController<List<Entity>> get entitiesController => _entitiesController;

  @override
  List<Entity> get selectedEntities => _selectedEntities;

  @override
  List<Entity> get copiedEntities => _copiedEntities;

  @override
  List<Entity> get cutEntities => _cutEntities;

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
