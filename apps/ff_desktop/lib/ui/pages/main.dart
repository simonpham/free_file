import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:ff_desktop/ui/ui.dart';

import 'package:ff_desktop/features/features.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.select((TabViewModel _) => _.currentExploreViewModel),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: MultiSplitViewTheme(
            data: MultiSplitViewThemeData(
              dividerThickness: Spacing.d4,
            ),
            child: MultiSplitView(
              axis: Axis.horizontal,
              initialAreas: [
                Area(
                  minimalSize: kSideBarMinimumSize,
                  size: kSideBarMinimumSize,
                ),
                Area(
                  minimalSize: kMainAreaMinimumSize,
                  size: kMainAreaDefaultSize,
                ),
              ],
              children: [
                const SideBar(),
                Padding(
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
                              .appTheme.color.navBarBackground.withTransparency,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              Spacing.d12,
                            ),
                            topRight: Radius.circular(
                              Spacing.d12,
                            ),
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
                              child: AddressBar(
                                key: Key('address_bar'),
                              ),
                            ),
                            if (ThemeConfigs().config.showSearchBar)
                              const HeheSearchBar(),
                          ],
                        ),
                      ),
                      ToolBar(onAction: (action) {
                        _handleAction(context, action);
                      }),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(
    BuildContext context,
    EntityContextAction action,
  ) {
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
        context.read<ExploreViewModel>().delete(entities: entities);
        break;
      case EntityContextAction.deletePermanently:
        context.read<ExploreViewModel>().deletePermanently(entities: entities);
        break;
      case EntityContextAction.rename:
        break;
      case EntityContextAction.properties:
        break;
      case EntityContextAction.unknown:
      default:
        break;
    }
  }
}
