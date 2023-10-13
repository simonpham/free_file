import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.only(
                bottom: Spacing.d8,
                right: Spacing.d8,
              ),
              child: Column(
                children: [
                  const HeheTabBar(),
                  Container(
                    height: Spacing.d40,
                    decoration: BoxDecoration(
                      color: context.appTheme.color.navBarBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          Spacing.d8,
                        ),
                        topRight: Radius.circular(
                          Spacing.d8,
                        ),
                      ),
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
          ),
        ],
      ),
    );
  }
}
