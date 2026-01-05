import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/features/features.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.select(
        (TabViewModel model) => model.currentExploreViewModel,
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: MultiSplitViewTheme(
            data: MultiSplitViewThemeData(dividerThickness: Spacing.d4),
            child: MultiSplitView(
              axis: Axis.horizontal,
              initialAreas: [
                Area(
                  min: kSideBarMinimumSize,
                  size: kSideBarMinimumSize,
                  builder: (context, area) {
                    return const SideBar();
                  },
                ),
                Area(
                  min: kMainAreaMinimumSize,
                  size: kMainAreaDefaultSize,
                  builder: (context, area) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: Spacing.d8,
                        right: Spacing.d8,
                      ),
                      child: Column(
                        children: [
                          const HeheTabBar(),
                          Container(
                            height: Spacing.d48,
                            decoration: BoxDecoration(
                              color: context
                                  .appTheme
                                  .color
                                  .navBarBackground
                                  .withTransparency,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Spacing.d12),
                                topRight: Radius.circular(Spacing.d12),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Spacing.d4,
                              horizontal: Spacing.d4,
                            ),
                            child: Row(
                              children: [
                                const NavBar(),
                                const Expanded(
                                  child: AddressBar(key: Key('address_bar')),
                                ),
                                if (ThemeConfigs().config.showSearchBar)
                                  const HeheSearchBar(),
                              ],
                            ),
                          ),
                          ToolBar(
                            onAction: (action) {
                              _handleAction(context, action);
                            },
                          ),
                          Expanded(
                            child: MainArea(
                              key: const Key('main_area'),
                              onAction: (action) {
                                _handleAction(context, action);
                              },
                            ),
                          ),
                          const StatusBar(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(BuildContext context, EntityContextAction action) {
    final entities = context.read<ExploreViewModel>().selectedEntities.toSet();
    switch (action) {
      case EntityContextAction.open when entities.length == 1:
        entities.first.doubleTap(context);
        break;
      case EntityContextAction.open:
        for (final entity in entities) {
          if (entity is Directory) {
            entity.openInNewTab(context);
          }
          if (entity is File) {
            entity.doubleTap(context);
          }
        }
        break;
      case EntityContextAction.openInNewWindow:
        break;
      case EntityContextAction.openInNewTab:
        context.read<TabViewModel>().openInNewTab();
        break;
      case EntityContextAction.pin:
        final tabModel = context.read<TabViewModel>();
        final uri =
            entities.firstOrNull?.path ??
            tabModel.currentExploreViewModel.currentUri;
        context.read<ExploreViewModel>().sideBarViewModel.togglePin(uri);
        context.read<TabViewModel>().exploreViewModels.forEach((model) {
          model.sideBarViewModel.refresh();
        });
        break;
      case EntityContextAction.quickLook:
        context.read<TabViewModel>().quickLook(entities: entities);
        break;
      case EntityContextAction.compress:
        context.read<TabViewModel>().compress(entities: entities);
        break;
      case EntityContextAction.copy:
        context.read<TabViewModel>().copy(entities: entities);
        break;
      case EntityContextAction.paste:
        context.read<TabViewModel>().paste();
        break;
      case EntityContextAction.move:
        context.read<TabViewModel>().move();
        break;
      case EntityContextAction.delete:
        _handleDelete(context, entities);
        break;
      case EntityContextAction.deletePermanently:
        _handleDeletePermanently(context, entities);
        break;
      case EntityContextAction.rename:
        context.read<ExploreViewModel>().startRename();
        break;
      case EntityContextAction.properties:
        break;
      case EntityContextAction.selectAll:
        final entities = context.read<ExploreViewModel>().entities.toSet();
        context.read<ExploreViewModel>().selectBatch(entities);
        break;
      case EntityContextAction.toggleShowHidden:
        context.read<ExploreViewModel>().toggleShowHidden();
        break;
      case EntityContextAction.unknown:
        break;
    }
  }

  Future<void> _handleDelete(BuildContext context, Set<Entity> entities) async {
    if (entities.isEmpty) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: 'Delete',
          content: 'Are you sure you want to delete ${entities.length} items?',
        );
      },
    );

    if (confirm != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<ExploreViewModel>().delete(entities: entities);
  }

  Future<void> _handleDeletePermanently(
    BuildContext context,
    Set<Entity> entities,
  ) async {
    if (entities.isEmpty) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: 'Delete Permanently',
          content:
              'Are you sure you want to delete ${entities.length} items permanently?',
        );
      },
    );

    if (confirm != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<ExploreViewModel>().deletePermanently(entities: entities);
  }
}
