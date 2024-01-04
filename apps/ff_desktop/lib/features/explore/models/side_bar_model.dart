import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/features/explore/models/tree_explore_model.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:storage/data/data.dart';
import 'package:utils/utils.dart';

class SideBarViewModel extends ChangeNotifier {
  EntityProvider get _local => injector.get<LocalEntityProvider>();

  Map<SideBarSection, List<TreeExploreViewModel>> _sections = {};

  Map<SideBarSection, List<TreeExploreViewModel>> get sections => _sections;

  SideBarViewModel() {
    _init();
  }

  void refresh() {
    _sections.clear();
    _sections = {};
    _init();
  }

  void togglePin(Uri uri) {
    final pinned = Settings().pinnedUris.toList();
    if (pinned.contains(uri)) {
      pinned.remove(uri);
    } else {
      pinned.add(uri);
    }
    Settings().pinnedUris = pinned;
  }

  Future<void> _init() async {
    for (final section in SideBarSection.values) {
      final List<TreeExploreViewModel> items = [];
      switch (section) {
        case SideBarSection.home:
          break;
        case SideBarSection.pinned:
          final pinned = Settings().pinnedUris;
          for (final uri in pinned) {
            final entity = await _local.get(uri);
            if (entity is Directory) {
              items.add(TreeExploreViewModel(entity, level: 0));
            }
          }
          break;
        case SideBarSection.cloud:
          if (kIsMacOs) {
            final icloudPath = PlatformUtils.getIcloudDrivePath();
            if (icloudPath.isNotEmpty) {
              final icloudUri = Uri.parse(icloudPath);
              final entity = await _local.get(icloudUri);
              if (entity is Directory) {
                items.add(
                  TreeExploreViewModel(
                    entity,
                    level: 0,
                    customIcon: Assets.icons.weather.outline.cloud,
                    customSelectedIcon: Assets.icons.weather.solid.cloud,
                  ),
                );
              }
            }
          }
          break;
        case SideBarSection.yours:
          for (final folder in PredefinedFolder.values) {
            if (folder == PredefinedFolder.home ||
                folder == PredefinedFolder.trash) {
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
            items.add(
              TreeExploreViewModel(
                directory,
                level: 0,
                customIcon: folder.icon,
                customSelectedIcon: folder.icon,
              ),
            );
          }
          break;
        case SideBarSection.drives:
          final path = PlatformUtils.getVolumesPath();
          if (path.isEmpty) {
            break;
          }
          final volumePath = Uri.parse(path);
          final entities = await _local.list(volumePath);
          for (final entity in entities) {
            if (entity is Directory) {
              items.add(
                TreeExploreViewModel(
                  entity,
                  level: 0,
                  customIcon: Assets.icons.device.outline.hardDrive,
                  customSelectedIcon: Assets.icons.device.solid.hardDrive,
                ),
              );
            }
          }
          break;
        case SideBarSection.tags:
          break;
      }
      sections[section] = items;
    }
    notifyListeners();
  }
}
