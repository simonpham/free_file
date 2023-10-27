import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/di.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

import 'package:ff_desktop/features/explore/explore.dart';
import 'package:utils/utils.dart';

class ExploreViewModel extends ChangeNotifier
    implements
        ExploreInterface,
        ExploreInterfaceSelectActions,
        ExploreInterfaceManipulateActions {
  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  ExploreViewModel() {
    refresh();
  }

  final List<Uri> _historyStack = [
    Uri.parse(PredefinedFolders.home.uri?.toFilePath() ?? kSlash)
  ];

  int _currentIndex = 0;

  List<Entity> _entities = [];
  List<Entity> _selectedEntities = [];
  List<Entity> _copiedEntities = [];
  List<Entity> _cutEntities = [];

  bool _showHidden = false;

  ViewMode _viewMode = ViewMode.list;

  ViewMode get viewMode => _viewMode;

  set viewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void toggleShowHidden() {
    _showHidden = !_showHidden;
    notifyListeners();
  }

  io.Directory get _currentDirectory => io.Directory(currentUri.toFilePath());

  @override
  Uri get currentUri => _historyStack[_currentIndex];

  @override
  List<Entity> get entities => _showHidden
      ? _entities
      : _entities.where((item) => !item.isHidden).toList();

  @override
  List<Entity> get selectedEntities => _selectedEntities;

  @override
  List<Entity> get copiedEntities => _copiedEntities;

  @override
  List<Entity> get cutEntities => _cutEntities;

  @override
  Future<void> refresh() async {
    _entities = [];
    notifyListeners();
    final entities = await _local.list(currentUri);
    _entities = entities;
    notifyListeners();
  }

  @override
  Future<void> goTo(Uri uri) async {
    if (canForward) {
      // Discard all forward history.
      _historyStack.removeRange(0, _currentIndex);
    }

    // Add new uri to history.
    _historyStack.insert(0, uri.trim());

    // Set index to the first element.
    _currentIndex = 0;
    refresh();
  }

  @override
  bool get canBack => _currentIndex < _historyStack.length - 1;

  @override
  bool get canForward => _currentIndex > 0;

  @override
  bool get canUp => _currentDirectory.parent.path != currentUri.toFilePath();

  @override
  void back() {
    if (canBack) {
      _currentIndex++;
      refresh();
    }
  }

  @override
  void forward() {
    if (canForward) {
      _currentIndex--;
      refresh();
    }
  }

  @override
  void up() {
    if (canUp) {
      final directory = io.Directory(currentUri.toFilePath());
      goTo(
        Uri.parse(directory.parent.absolute.path),
      );
    }
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
  void selectBatch(List<Entity> entities) {
    _selectedEntities = entities;
    notifyListeners();
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
