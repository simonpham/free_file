import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
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

  final SideBarViewModel _sideBarViewModel = SideBarViewModel();

  SideBarViewModel get sideBarViewModel => _sideBarViewModel;

  final TextEditingController _addressBarController = TextEditingController();

  TextEditingController get addressBarController => _addressBarController;

  bool _isRenaming = false;
  bool get isRenaming => _isRenaming;
  final FocusNode _entityNameFocusNode = FocusNode();
  FocusNode get entityNameFocusNode => _entityNameFocusNode;
  final TextEditingController _entityNameController = TextEditingController();
  TextEditingController get entityNameController => _entityNameController;

  final List<Uri> _historyStack = [
    Uri.parse(PredefinedFolders.home.uri?.toFilePath() ?? kSlash)
  ];

  int _currentIndex = 0;

  List<Entity> _entities = [];
  Set<Entity> _selectedEntities = {};

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
  Future<void> refresh({bool maintainState = false}) async {
    if (!maintainState) {
      _entities = [];
    }
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
    await refresh();
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
  Future<void> delete({Set<Entity>? entities}) async {
    final trashUri = PredefinedFolders.trash.uri;
    if (trashUri == null) {
      return;
    }

    bool? needRefresh;
    final entitiesToDelete = (entities ?? _selectedEntities).toSet();
    for (final entity in entitiesToDelete) {
      if (entity.type == EntityType.directory) {
        trashUri.lastNonEmptySegment;
        await _local.moveDirectory(entity.path, trashUri.append(entity.name));
        needRefresh ??= true;
      }
      if (entity.type == EntityType.file) {
        await _local.moveFile(entity.path, trashUri.append(entity.name));
        needRefresh ??= true;
      }
    }

    if (needRefresh != true) {
      return;
    }
    refresh(maintainState: true);
  }

  @override
  Future<void> deletePermanently({Set<Entity>? entities}) async {
    final entitiesToDelete = (entities ?? _selectedEntities).toSet();
    bool? needRefresh;
    for (final entity in entitiesToDelete) {
      if (entity.type == EntityType.directory) {
        await _local.deleteDirectory(entity.path);
        needRefresh ??= true;
      }
      if (entity.type == EntityType.file) {
        await _local.deleteFile(entity.path);
        needRefresh ??= true;
      }
    }

    if (needRefresh != true) {
      return;
    }
    refresh(maintainState: true);
  }

  @override
  void startRename() {
    if (_selectedEntities.isEmpty) {
      return;
    }

    final entity = _selectedEntities.firstOrNull;
    if (entity == null) {
      return;
    }

    _isRenaming = true;
    notifyListeners();
    _entityNameController.text = entity.name;
    Future.delayed(
      FludaDuration.ms,
      () => _entityNameFocusNode.requestFocus(),
    );
  }

  @override
  Future<void> finishRename({
    Set<Entity>? entities,
    required String newName,
  }) async {
    final entitiesToRename = (entities ?? _selectedEntities).toSet();
    bool? needRefresh;

    // TODO: Support batch rename.
    final firstEntity = entitiesToRename.firstOrNull;
    if (firstEntity == null) {
      return;
    }

    if (firstEntity.type == EntityType.directory) {
      await _local.renameDirectory(firstEntity.path, newName);
      needRefresh ??= true;
    }

    if (firstEntity.type == EntityType.file) {
      await _local.renameFile(firstEntity.path, newName);
      needRefresh ??= true;
    }

    _isRenaming = false;
    _entityNameController.text = '';
    _entityNameFocusNode.unfocus();
    notifyListeners();

    if (needRefresh != true) {
      return;
    }

    refresh(maintainState: true);
  }

  @override
  void abortRename() {
    _isRenaming = false;
    _entityNameController.text = '';
    _entityNameFocusNode.unfocus();
    notifyListeners();
  }

  @override
  void selectBatch(Set<Entity> entities) {
    if (_isRenaming) {
      abortRename();
    }

    if (_isSelectModeEnabled) {
      for (int i = entities.length - 1; i >= 0; i--) {
        final entity = entities.elementAt(i);
        _selectedEntities.add(entity);
      }
    } else {
      _selectedEntities = entities;
    }
    notifyListeners();
  }

  @override
  void select(
    Entity entity, {
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  }) {
    if (_isRenaming) {
      abortRename();
    }

    final selectedEntities = _selectedEntities;
    if (isPressedControlCommand && !selectedEntities.contains(entity)) {
      _selectedEntities.add(entity);
      notifyListeners();
      return;
    }

    if (isPressedControlCommand && selectedEntities.contains(entity)) {
      _selectedEntities.remove(entity);
      notifyListeners();
      return;
    }

    if (isPressedShift && selectedEntities.isNotEmpty) {
      final entities = _entities;
      final indexOfEntity = entities.indexOf(entity);
      final indexOfFirstSelectedEntity =
          entities.indexOf(selectedEntities.first);
      final indexOfLastSelectedEntity = entities.indexOf(selectedEntities.last);
      final minIndex = indexOfFirstSelectedEntity < indexOfLastSelectedEntity
          ? indexOfFirstSelectedEntity
          : indexOfLastSelectedEntity;
      final maxIndex = indexOfFirstSelectedEntity > indexOfLastSelectedEntity
          ? indexOfFirstSelectedEntity
          : indexOfLastSelectedEntity;
      final minIndexToSelect =
          indexOfEntity < minIndex ? indexOfEntity : minIndex;
      final maxIndexToSelect =
          indexOfEntity > maxIndex ? indexOfEntity : maxIndex;
      final entitiesToSelect =
          entities.sublist(minIndexToSelect, maxIndexToSelect + 1);
      _selectedEntities = entitiesToSelect.toSet();
      notifyListeners();
      return;
    }

    if (_isSelectModeEnabled) {
      _selectedEntities.add(entity);
    } else {
      _selectedEntities = {entity};
    }
    notifyListeners();
  }

  @override
  void unselect(Entity entity) {
    if (_isRenaming) {
      abortRename();
    }

    _selectedEntities.remove(entity);
    notifyListeners();
  }

  @override
  bool get isSelectModeEnabled => _isSelectModeEnabled;

  void _clearSelectedEntities() {
    if (_isRenaming) {
      abortRename();
    }

    if (!_isSelectModeEnabled) {
      _selectedEntities = {};
    }
  }
}
