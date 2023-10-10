import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:ff_desktop/ui/ui.dart';

class MainPage extends StatelessWidget {
  static const String routePath = '/';

  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: Spacing.d36,
                  child: const Row(
                    children: [
                      Expanded(
                        child: HeheTabBar(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Spacing.d40,
                  child: const Row(
                    children: [
                      NavBar(),
                      Expanded(
                        child: AddressBar(),
                      ),
                      HeheSearchBar(),
                    ],
                  ),
                ),
                const ToolBar(),
                const Expanded(
                  child: MainArea(),
                ),
                SizedBox(
                  height: Spacing.d32,
                  child: const Row(
                    children: [
                      Expanded(
                        child: StatusBar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
