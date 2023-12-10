import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:ff_desktop/features/features.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:utils/utils.dart';

class TabViewModel extends ChangeNotifier {
  StreamSubscription? _shortcutSubscription;

  EventBus get eventBus => injector.get<EventBus>();

  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  TabViewModel() {
    _shortcutSubscription?.cancel();
    _shortcutSubscription =
        eventBus.on<ShortcutEvent>().listen(_handleShortcut);
  }

  @override
  void dispose() {
    _shortcutSubscription?.cancel();
    _shortcutSubscription = null;
    for (var element in _exploreViewModels) {
      element.dispose();
    }
    _exploreViewModels.clear();
    super.dispose();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Set<Entity> _copiedEntities = {};

  Future<List<String>> get _copiedPaths {
    return Pasteboard.files();
  }

  bool _isRemovingTab = false;

  void _setIndex(int index) {
    _currentIndex = max(0, min(index, _exploreViewModels.length - 1));
  }

  Future<void> copy({Set<Entity>? entities}) async {
    _copiedEntities = entities ?? currentExploreViewModel.selectedEntities;
    await Pasteboard.writeFiles(
      _copiedEntities.map((e) => e.path.toFilePath()).toList(),
    );
    notifyListeners();
  }

  Future<void> paste({Uri? path}) async {
    if (_copiedEntities.isEmpty) {
      return;
    }

    path ??= currentExploreViewModel.currentUri;

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
    await currentExploreViewModel.refresh();
    currentExploreViewModel.selectBatch(currentExploreViewModel.entities
        .where((item) => pathToSelects.contains(item.path.toFilePath()))
        .toSet());
  }

  void changeTab(int index) {
    _setIndex(index);
    notifyListeners();
  }

  void nextTab() {
    final isLastTab = _currentIndex == _exploreViewModels.length - 1;
    if (isLastTab) {
      changeTab(0);
      return;
    }
    changeTab(_currentIndex + 1);
  }

  void previousTab() {
    final isFirstTab = _currentIndex == 0;
    if (isFirstTab) {
      changeTab(_exploreViewModels.length - 1);
      return;
    }
    changeTab(_currentIndex - 1);
  }

  final List<ExploreViewModel> _exploreViewModels = [
    ExploreViewModel(),
  ];

  ExploreViewModel get currentExploreViewModel =>
      _exploreViewModels[_currentIndex];

  List<ExploreViewModel> get exploreViewModels => _exploreViewModels;

  void addTab() {
    final currentTab = currentExploreViewModel;
    final newTab = ExploreViewModel()..goTo(currentTab.currentUri);
    _exploreViewModels.add(newTab);
    _setIndex(_exploreViewModels.length - 1);
    notifyListeners();
  }

  void closeAllTabs() {
    _exploreViewModels.clear();
    _exploreViewModels.add(ExploreViewModel());
    _setIndex(0);
    notifyListeners();
  }

  void removeExploreViewModelAt(int index) {
    if (_isRemovingTab) {
      return;
    }
    if (_exploreViewModels.length == 1) {
      return;
    }
    _isRemovingTab = true;
    if (index <= _currentIndex) {
      _setIndex(index - 1);
      notifyListeners();
    }

    _exploreViewModels.removeAt(index);
    notifyListeners();
    _isRemovingTab = false;
  }

  Future<void> refreshClipboard() async {
    final copiedPaths = await Pasteboard.files();
    printLog('[TabViewModel] refreshClipboard: $copiedPaths');
    if (copiedPaths.isEmpty) {
      return;
    }

    final List<Entity> copiedEntities = [];
    for (var copiedPath in copiedPaths) {
      try {
        final uri = Uri.parse(copiedPath);
        final copiedEntity = await _local.get(uri);
        if (copiedEntity == null) {
          continue;
        }
        copiedEntities.add(copiedEntity);
      } catch (err, trace) {
        printError(err, trace);
      }
    }
    _copiedEntities = copiedEntities.toSet();
    notifyListeners();
  }

  void _handleShortcut(ShortcutEvent event) {
    switch (event.runtimeType) {
      case const (AddTabEvent):
        addTab();
        break;
      case const (CloseAllTabsEvent):
        closeAllTabs();
        break;
      case const (CloseTabEvent):
        removeExploreViewModelAt(_currentIndex);
        break;
      case const (NextTabEvent):
        nextTab();
        break;
      case const (PreviousTabEvent):
        previousTab();
        break;
      case const (CopyEvent):
        copy();
        break;
      case const (PasteEvent):
        paste();
        break;
      default:
        printLog(
          '[TabViewModel] Unhandled shortcut event: ${event.runtimeType}',
        );
        break;
    }
  }
}
