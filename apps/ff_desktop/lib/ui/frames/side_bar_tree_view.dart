import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, _) {
        return Selector<TreeExploreViewModel, bool>(
          selector: (context, model) => model.isExpanded,
          builder: (context, isExpanded, _) {
            return Padding(
              padding: EdgeInsets.only(
                left: model.level * Spacing.d8,
              ),
              child: Column(
                children: [
                  Consumer<ExploreViewModel>(
                    builder: (context, exploreViewModel, _) {
                      return SideBarItem(
                        title: model.directory.name,
                        uri: model.directory.path,
                        onTap: () {
                          if (!model.isExpanded) {
                            model.toggle();
                          }
                          exploreViewModel.goTo(model.directory.path);
                        },
                        selected: exploreViewModel.currentUri.trim() ==
                            model.directory.path.trim(),
                        icon: Assets.icons.filesAndFolder.outline.folder,
                        selectedIcon: Assets.icons.filesAndFolder.solid.folder,
                        suffix: Tappable(
                          onTap: () {
                            model.toggle();
                          },
                          child: model.isExpanded
                              ? ImageView(
                                  Assets.icons.arrows.outline.upArrow,
                                  size: Spacing.d16,
                                )
                              : ImageView(
                                  Assets.icons.arrows.outline.downArrow,
                                  size: Spacing.d16,
                                ),
                        ),
                      );
                    },
                  ),
                  if (isExpanded)
                    for (final directory in model.directories)
                      SideBarTreeView(
                        model: directory,
                      ),
                  if (isExpanded)
                    for (final file in model.files)
                      SideBarItem(
                        title: file.name,
                        uri: file.path,
                        onTap: () {},
                        icon: Assets.icons.filesAndFolder.outline.file04,
                        selectedIcon: Assets.icons.filesAndFolder.solid.file04,
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
