import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeModel>();
    return ChangeNotifierProvider.value(
      value: context.select((ExploreViewModel _) => _.sideBarViewModel),
      child: TitlebarSafeArea(
        child: AnimatedContainer(
          duration: FludaDuration.ms3,
          width: kSideBarMinimumSize,
          curve: Curves.easeOut,
          child: Selector<SideBarViewModel,
              Map<SideBarSections, List<TreeExploreViewModel>>>(
            selector: (context, model) => model.sections,
            builder: (
              BuildContext context,
              Map<SideBarSections, List<TreeExploreViewModel>> sections,
              Widget? _,
            ) {
              return Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        for (final MapEntry<SideBarSections,
                                List<TreeExploreViewModel>> entry
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
                                      selectedIcon:
                                          entry.key.getSelectedIcon(context),
                                      textStyle: context
                                          .theme.textTheme.bodyLarge
                                          ?.copyWith(
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

class SideBarSection extends StatelessWidget {
  final SideBarSections section;
  final List<TreeExploreViewModel> items;

  const SideBarSection({
    super.key,
    required this.section,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final uri = section.uri;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: Spacing.d24,
            bottom: Spacing.d4,
          ),
          sliver: SliverToBoxAdapter(
            child: SideBarItem(
              uri: uri,
              title: section.getLabel(context),
              // selected: model.currentUri == uri,
              onTap: uri != null
                  ? () {
                      // widget.onGoTo(uri);
                    }
                  : null,
              icon: section.getIcon(context),
              selectedIcon: section.getSelectedIcon(context),
              textStyle: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            final item = items[index];
            return SideBarTreeView(
              model: item,
            );
          },
          itemCount: items.length,
        ),
      ],
    );
  }
}
