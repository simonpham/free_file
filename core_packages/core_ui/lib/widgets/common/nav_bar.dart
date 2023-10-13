import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class NavDestination {
  const NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.iconColor,
    required this.label,
    this.trailing,
    this.routePath,
    this.onTap,
  });

  final String icon;
  final String selectedIcon;
  final Color iconColor;
  final String label;
  final Widget? trailing;
  final String? routePath;
  final Function? onTap;
}

class SfNavBar extends StatelessWidget {
  final List<NavDestination> destinations;
  final int? selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  final Widget? leading;
  final Widget? secondarySection;
  final Widget? trailing;

  final bool isExpanded;

  const SfNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.leading,
    this.secondarySection,
    this.trailing,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (leading != null) ...[
          leading!,
        ],
        ListView.builder(
          itemCount: destinations.length,
          padding: EdgeInsets.only(
            left: Spacing.d16,
            right: Spacing.d16,
            top: leading == null ? 0.0 : Spacing.d16,
            bottom: trailing == null ? 0.0 : Spacing.d16,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final dest = destinations[index];
            final selected = index == selectedIndex;
            return Padding(
              padding: isExpanded
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(
                      horizontal: Spacing.d8,
                    ),
              child: ListItem(
                hideTitleOnHandyDevice: true,
                hideTrailingOnHandyDevice: true,
                isSelected: selected,
                padding: isExpanded ? null : EdgeInsets.all(Spacing.d12),
                leading: Padding(
                  padding: EdgeInsets.all(Spacing.d1 * 3),
                  child: SvgPicture.asset(
                    selected ? dest.selectedIcon : dest.icon,
                    height: Spacing.d24,
                    width: Spacing.d24,
                    colorFilter: ColorFilter.mode(
                      dest.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                hoverOverlayColorTint: dest.iconColor,
                title: Text(
                  destinations[index].label,
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    color:
                        selected ? Colors.grey.shade900 : Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isExpanded ? dest.trailing : null,
                onTap: () {
                  if (dest.onTap != null) {
                    dest.onTap?.call();
                    return;
                  }
                  onDestinationSelected?.call(index);
                },
              ),
            );
          },
        ),
        if (secondarySection != null) ...[
          const Divider(),
          secondarySection!,
        ],
        if (secondarySection == null) const Spacer(),
        if (trailing != null) ...[
          trailing!,
        ],
      ],
    );
  }
}
