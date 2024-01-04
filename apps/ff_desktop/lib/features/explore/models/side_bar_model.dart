import 'package:core/core.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/features/explore/models/tree_explore_model.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:storage/data/data.dart';
import 'package:utils/utils.dart';

class SideBarViewModel extends ChangeNotifier {
  EntityProvider get _local => injector.get<LocalEntityProvider>();

  final Map<SideBarSections, List<TreeExploreViewModel>> sections = {};

  SideBarViewModel() {
    _init();
  }

  Future<void> _init() async {
    for (final section in SideBarSections.values) {
      final List<TreeExploreViewModel> items = [];
      switch (section) {
        case SideBarSections.home:
          break;
        case SideBarSections.pinned:
          final pinned = Settings().sideBarFavorites;
          for (final uri in pinned) {
            final entity = await _local.get(uri);
            if (entity is Directory) {
              items.add(TreeExploreViewModel(entity, level: 0));
            }
          }
          break;
        case SideBarSections.cloud:
          break;
        case SideBarSections.yours:
          for (final folder in PredefinedFolders.values) {
            if (folder == PredefinedFolders.home ||
                folder == PredefinedFolders.trash) {
              continue;
            }
            final uri = folder.uri;
            if (uri == null) {
              continue;
            }
            final now = DateTime.now().toIso8601String();
            final directory = Directory(
              name: folder.name.capitalize(),
              path: uri.trim(),
              isHidden: false,
              createdAt: now,
              updatedAt: now,
            );
            items.add(TreeExploreViewModel(directory, level: 0));
          }
          break;
        case SideBarSections.drives:
          final path = PlatformUtils.getVolumesPath();
          if (path.isEmpty) {
            break;
          }
          final volumePath = Uri.parse(path);
          final entities = await _local.list(volumePath);
          for (final entity in entities) {
            if (entity is Directory) {
              items.add(TreeExploreViewModel(entity, level: 0));
            }
          }
          break;
        case SideBarSections.tags:
          break;
      }
      sections[section] = items;
    }
    notifyListeners();
  }
}
