import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:ff_desktop/features/features.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/models/models.dart';

class TabViewModel extends ChangeNotifier with WorkspaceCopyPasteMixin {
  StreamSubscription? _shortcutSubscription;

  EventBus get eventBus => injector.get<EventBus>();

  final ItemScrollController tabScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  TabViewModel() {
    _shortcutSubscription?.cancel();
    _shortcutSubscription =
        eventBus.on<ShortcutEvent>().listen(_handleShortcut);
    itemPositionsListener.itemPositions
        .addListener(_handleItemPositionsChanged);
  }

  @override
  void dispose() {
    _shortcutSubscription?.cancel();
    _shortcutSubscription = null;
    itemPositionsListener.itemPositions
        .removeListener(_handleItemPositionsChanged);
    for (var element in _exploreViewModels) {
      element.dispose();
    }
    _exploreViewModels.clear();
    super.dispose();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  bool _isRemovingTab = false;

  void _handleItemPositionsChanged() {
    // Check if _currentIndex is still in view. If not, scroll to it.
    final itemPositions = itemPositionsListener.itemPositions.value;
    final isCurrentIndexInView =
        itemPositions.where((item) => item.index == _currentIndex).isNotEmpty;
    if (isCurrentIndexInView) {
      return;
    }
    final align = _currentIndex == 0 ? 0.0 : 0.5;
    tabScrollController.jumpTo(
      index: _currentIndex,
      alignment: align,
    );
  }

  void _setIndex(int index) {
    _currentIndex = max(0, min(index, _exploreViewModels.length - 1));
    notifyListeners();
  }

  void changeTab(int index) {
    _setIndex(index);
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

  @override
  ExploreViewModel get currentExploreViewModel =>
      _exploreViewModels[_currentIndex];

  List<ExploreViewModel> get exploreViewModels => _exploreViewModels;

  void addTab([ExploreViewModel? viewModel]) {
    final currentTab = currentExploreViewModel;
    final newTab =
        viewModel ?? (ExploreViewModel()..goTo(currentTab.currentUri));
    _exploreViewModels.add(newTab);
    _setIndex(_exploreViewModels.length - 1);
  }

  void closeAllTabs() {
    _exploreViewModels.clear();
    _exploreViewModels.add(ExploreViewModel());
    _setIndex(0);
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
    }

    _exploreViewModels.removeAt(index);
    notifyListeners();
    _isRemovingTab = false;
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
      case const (QuickLookEvent):
        quickLook();
        break;
      case const (CompressEvent):
        compress();
        break;
      default:
        printLog(
          '[TabViewModel] Unhandled shortcut event: ${event.runtimeType}',
        );
        break;
    }
  }

  Future<void> quickLook({Set<Entity>? entities}) async {
    entities ??= currentExploreViewModel.selectedEntities;
    await PlatformUtils.openQuickLook(
      entities.map((item) => item.path.toFilePath()).toList(),
      workingDirectory: currentExploreViewModel.currentUri,
    );
  }

  Future<void> compress({Set<Entity>? entities}) async {
    entities ??= currentExploreViewModel.selectedEntities;
    Directory? firstDirectory;

    final List<String> pathsToCompress = [];
    for (final entity in entities) {
      if (entity is Directory) {
        firstDirectory ??= entity;
      }
      pathsToCompress.add(entity.path.toFilePath());
    }

    final (zipFile, error) = await PlatformUtils.compress(
      pathsToCompress,
      fileName: firstDirectory?.name ?? 'archive',
      workingDirectory: currentExploreViewModel.currentUri,
    );

    if (error != null) {
      return;
    }

    await currentExploreViewModel.refresh();
    currentExploreViewModel.selectBatch(currentExploreViewModel.entities
        .where((item) => item.path.toFilePath() == zipFile)
        .toSet());
  }
}
