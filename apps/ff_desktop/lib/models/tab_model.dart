import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:ff_desktop/features/features.dart';

class TabViewModel extends ChangeNotifier {
  StreamSubscription? _shortcutSubscription;

  EventBus get eventBus => injector.get<EventBus>();

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

  bool _isRemovingTab = false;

  void _setIndex(int index) {
    _currentIndex = max(0, min(index, _exploreViewModels.length - 1));
  }

  void changeTab(int index) {
    _setIndex(index);
    notifyListeners();
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

  void _handleShortcut(ShortcutEvent event) {
    if (event is AddTabEvent) {
      addTab();
      return;
    }
    if (event is CloseTabEvent) {
      removeExploreViewModelAt(_currentIndex);
      return;
    }
  }
}
