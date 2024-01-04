import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context); // rebuild on resize.
    return ChangeNotifierProvider.value(
      value: context.select((ExploreViewModel _) => _.sideBarViewModel),
      child: TitlebarSafeArea(
        child: AnimatedContainer(
          duration: FludaDuration.ms3,
          width: kSideBarMinimumSize,
          curve: Curves.easeOut,
          child: Selector<SideBarViewModel,
              Map<SideBarSection, List<TreeExploreViewModel>>>(
            selector: (context, model) => model.sections,
            builder: (
              BuildContext context,
              Map<SideBarSection, List<TreeExploreViewModel>> sections,
              Widget? _,
            ) {
              return Column(
                children: [
                  Expanded(
                    child: SideBarSectionsWidget(
                      sections: sections,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Spacing.d8,
                      horizontal: Spacing.d24,
                    ),
                    child: const ThemeToggle(
                      isCollapsed: false,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class SideBarSectionsWidget extends StatelessWidget {
  final Map<SideBarSection, List<TreeExploreViewModel>> sections;

  const SideBarSectionsWidget({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }
    return CustomScrollView(
      slivers: [
        for (final MapEntry<SideBarSection, List<TreeExploreViewModel>> entry
            in sections.entries)
          if (entry.value.isNotEmpty) ...[
            SliverPadding(
              padding: EdgeInsets.only(
                top: Spacing.d24,
                bottom: Spacing.d4,
              ),
              sliver: SliverToBoxAdapter(
                child: Consumer<ExploreViewModel>(
                  builder: (context, model, _) {
                    final uri = entry.key.uri;
                    return SideBarItem(
                      level: 0,
                      uri: uri,
                      title: entry.key.getLabel(context),
                      selected: model.currentUri == uri,
                      onTap: uri != null
                          ? () {
                              model.goTo(uri);
                            }
                          : null,
                      icon: entry.key.getIcon(context),
                      selectedIcon: entry.key.getSelectedIcon(context),
                      textStyle: context.theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                final item = entry.value[index];
                return SideBarTreeView(
                  model: item,
                );
              },
              itemCount: entry.value.length,
            ),
          ],
      ],
    );
  }
}
