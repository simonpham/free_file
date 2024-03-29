import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/platform_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class SideBarTreeView extends StatelessWidget {
  final TreeExploreViewModel model;

  const SideBarTreeView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final icloudPath = PlatformUtils.getIcloudDrivePath();
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, _) {
        return Selector<TreeExploreViewModel, bool>(
          selector: (context, model) => model.isExpanded,
          builder: (context, isExpanded, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ExploreViewModel>(
                  builder: (context, exploreViewModel, _) {
                    final isIcloud = icloudPath.isNotEmpty &&
                        model.directory.path.toRealPath() == icloudPath;
                    return SideBarItem(
                      level: model.level,
                      title: isIcloud ? 'iCloud Drive' : model.directory.name,
                      uri: model.directory.path,
                      onTap: () {
                        if (!model.isExpanded) {
                          model.toggle();
                        }
                        exploreViewModel.goTo(model.directory.path);
                      },
                      selected: exploreViewModel.currentUri.trim() ==
                          model.directory.path.trim(),
                      icon: model.isExpanded && model.isExpandable
                          ? model.customIcon ??
                              Assets.icons.filesAndFolder.outline.folder
                          : model.customIcon ??
                              Assets.icons.filesAndFolder.outline.folder03,
                      selectedIcon: model.isExpanded && model.isExpandable
                          ? model.customSelectedIcon ??
                              Assets.icons.filesAndFolder.solid.folder
                          : model.customSelectedIcon ??
                              Assets.icons.filesAndFolder.solid.folder03,
                      iconColor:
                          model.directory.getEntityColor(context.appTheme),
                      expanded: isExpanded,
                      expandable: model.isExpandable,
                      onToggleExpand: () {
                        model.toggle();
                      },
                    );
                  },
                ),
                if (isExpanded)
                  for (final directory in model.directories)
                    SideBarTreeView(
                      model: directory,
                    ),
                if (isExpanded && ThemeConfigs().config.showFileInSideBar)
                  for (final file in model.files)
                    SideBarItem(
                      level: model.level + 1,
                      title: file.name,
                      uri: file.path,
                      onTap: () {},
                      icon: file.icon,
                      iconColor: file.getEntityColor(context.appTheme),
                    ),
              ],
            );
          },
        );
      },
    );
  }
}
