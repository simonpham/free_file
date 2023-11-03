import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';
import 'package:ff_desktop/ui/ui.dart';
import 'package:utils/utils.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.select((TabViewModel _) => _.currentExploreViewModel),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        body: MultiSplitView(
          axis: Axis.horizontal,
          initialAreas: [
            Area(minimalSize: kSideBarMinimumSize, size: kSideBarMinimumSize),
            Area(minimalSize: kMainAreaMinimumSize, size: kMainAreaDefaultSize),
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
                    child: const Row(
                      children: [
                        NavBar(),
                        Expanded(
                          child: AddressBar(
                            key: Key('address_bar'),
                          ),
                        ),
                        HeheSearchBar(),
                      ],
                    ),
                  ),
                  const ToolBar(),
                  const Expanded(
                    child: MainArea(
                      key: Key('main_area'),
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
  }
}
