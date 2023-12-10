import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:local_entity_provider/local_entity_provider.dart';

import 'package:ff_desktop/features/explore/explore.dart';
import 'package:pasteboard/pasteboard.dart';
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

  final SideBarViewModel _sideBarViewModel = SideBarViewModel();

  SideBarViewModel get sideBarViewModel => _sideBarViewModel;

  final TextEditingController _addressBarController = TextEditingController();

  TextEditingController get addressBarController => _addressBarController;

  final List<Uri> _historyStack = [
    Uri.parse(PredefinedFolders.home.uri?.toFilePath() ?? kSlash)
  ];

  int _currentIndex = 0;

  List<Entity> _entities = [];
  Set<Entity> _selectedEntities = {};
  Set<Entity> _copiedEntities = {};

  Future<List<String>> get _copiedPaths {
    return Pasteboard.files();
  }

  bool _showHidden = false;
  bool _isSelectModeEnabled = false;

  void toggleSelectMode() {
    _isSelectModeEnabled = !_isSelectModeEnabled;
    _clearSelectedEntities();
    notifyListeners();
  }

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
  Set<Entity> get selectedEntities => _selectedEntities;

  @override
  Set<Entity> get copiedEntities => _copiedEntities;

  @override
  Future<void> refresh() async {
    _entities = [];
    _addressBarController.text = currentUri.toFilePath();
    notifyListeners();
    final entities = await _local.list(currentUri);
    _entities = entities;
    _clearSelectedEntities();
    notifyListeners();
  }

  @override
  Future<void> goTo(Uri uri) async {
    final io.Directory dir = io.Directory(uri.toFilePath());
    final stat = await dir.stat();

    // Reset address bar text.
    _addressBarController.text = currentUri.toFilePath();

    // Check if uri is a file.
    if (stat.type != io.FileSystemEntityType.directory) {
      // Open file.
      final error = await PlatformUtils.open(
        uri,
        workingDirectory: currentUri,
      );
      if (error != null) {
        throw FreeError(error);
      }
      return;
    }

    // Check if directory exists.
    final isExisted = await dir.exists();
    if (!isExisted) {
      throw const FreeError(Error.directoryNotFound);
    }

    // Skip if the same directory.
    if (uri.toFilePath() == currentUri.toFilePath()) {
      return;
    }

    // End of checks. Just navigate.
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
  Future<void> copy({Set<Entity>? entities}) async {
    _copiedEntities = entities ?? _selectedEntities;
    await Pasteboard.writeFiles(
      _copiedEntities.map((e) => e.path.toFilePath()).toList(),
    );
    notifyListeners();
  }

  @override
  Future<Entity> createDirectory({Uri? path, required String name}) {
    // TODO: implement createDirectory
    throw UnimplementedError();
  }

  @override
  Future<Entity> createFile({Uri? path, required String name}) {
    // TODO: implement createFile
    throw UnimplementedError();
  }

  @override
  void delete({Entity? entity}) {
    // TODO: implement delete
  }

  @override
  Future<void> paste({Uri? path}) async {
    if (_copiedEntities.isEmpty) {
      return;
    }

    path ??= currentUri;

    final copiedPaths = await _copiedPaths;
    if (copiedPaths.isEmpty) {
      return;
    }

    final List<String> pathToSelects = [];
    for (var copiedPath in copiedPaths) {
      final copiedEntity = _copiedEntities.firstWhere(
        (item) => item.path.toFilePath() == copiedPath,
      );
      final newPath = path.resolve(path.path + kSlash + copiedEntity.name);
      if (copiedEntity is File) {
        await _local.copyFile(copiedEntity.path, newPath);
      } else if (copiedEntity is Directory) {
        await _local.copyDirectory(copiedEntity.path, newPath);
      }

      pathToSelects.add(newPath.toFilePath());
    }

    await Pasteboard.writeFiles(const []);
    _copiedEntities = {};
    await refresh();
    selectBatch(_entities
        .where((item) => pathToSelects.contains(item.path.toFilePath()))
        .toSet());
  }

  @override
  void rename({Entity? entity, required String name}) {
    // TODO: implement rename
  }

  @override
  void selectBatch(Set<Entity> entities) {
    if (_isSelectModeEnabled) {
      _selectedEntities.addAll(entities);
    } else {
      _selectedEntities = entities;
    }
    notifyListeners();
  }

  @override
  void select(Entity entity) {
    if (_isSelectModeEnabled) {
      _selectedEntities.add(entity);
    } else {
      _selectedEntities = {entity};
    }
    notifyListeners();
  }

  @override
  void unselect(Entity entity) {
    _selectedEntities.remove(entity);
    notifyListeners();
  }

  @override
  bool get isSelectModeEnabled => _isSelectModeEnabled;

  void _clearSelectedEntities() {
    if (!_isSelectModeEnabled) {
      _selectedEntities = {};
    }
  }
}
