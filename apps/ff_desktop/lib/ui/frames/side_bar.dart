import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

extension on ScreenSize {
  double get sideBarWidth {
    switch (this) {
      case ScreenSize.extraLarge:
        return Spacing.d64 * 5;
      case ScreenSize.larger:
        return Spacing.d64 * 4;
      default:
        return Spacing.d64 * 3;
    }
  }
}

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: FludaDuration.ms3,
      width: context.screenSize.sideBarWidth,
      curve: Curves.easeOut,
      color: Colors.red,
      child: const Center(
        child: Text('Side Bar'),
      ),
    );
  }
}
