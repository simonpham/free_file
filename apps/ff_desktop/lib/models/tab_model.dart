import 'package:flutter/foundation.dart';
import 'package:ff_desktop/features/features.dart';

class TabViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<ExploreViewModel> _exploreViewModels = [
    ExploreViewModel(),
  ];

  ExploreViewModel get currentExploreViewModel =>
      _exploreViewModels[_currentIndex];

  List<ExploreViewModel> get exploreViewModels => _exploreViewModels;

  void addExploreViewModel(ExploreViewModel viewModel) {
    _exploreViewModels.add(viewModel);
    notifyListeners();
  }

  void removeExploreViewModelAt(int index) {
    _exploreViewModels.removeAt(index);
    notifyListeners();
  }
}
