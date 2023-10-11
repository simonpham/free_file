import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

extension on ScreenSize {
  double get searchBarWidth {
    switch (this) {
      case ScreenSize.extraLarge:
        return Spacing.d32 * 10;
      case ScreenSize.larger:
        return Spacing.d32 * 8;
      case ScreenSize.large:
        return Spacing.d32 * 6;
      case ScreenSize.normal:
        return Spacing.d32 * 5;
      case ScreenSize.small:
      default:
        return Spacing.d64;
    }
  }
}

class HeheSearchBar extends StatelessWidget {
  const HeheSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: Spacing.d40,
      duration: FludaDuration.ms3,
      width: context.screenSize.searchBarWidth,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(
          Spacing.d8,
        ),
      ),
      margin: EdgeInsets.all(
        Spacing.d4,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: context.theme.colorScheme.onSurfaceVariant,
          ),
          Text(
            'Search',
            style: TextStyle(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
