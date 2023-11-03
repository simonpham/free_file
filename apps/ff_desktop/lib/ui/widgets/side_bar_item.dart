import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class SideBarItem extends StatelessWidget {
  final String? title;
  final Uri? uri;
  final VoidCallback? onTap;

  final int level;

  final bool selected;
  final bool expanded;
  final bool expandable;

  final SvgGenImage? icon;
  final SvgGenImage? selectedIcon;
  final Color? iconColor;
  final TextStyle? textStyle;

  final VoidCallback? onToggleExpand;

  const SideBarItem({
    super.key,
    this.title,
    this.uri,
    this.onTap,
    this.icon,
    this.selectedIcon,
    this.textStyle,
    this.level = 0,
    this.selected = false,
    this.expanded = false,
    this.expandable = false,
    this.onToggleExpand,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d32,
      margin: EdgeInsets.only(
        left: Spacing.d8,
      ),
      child: Tappable(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
            left: level * Spacing.d8 + (expandable ? 0.0 : Spacing.d20),
          ),
          decoration: BoxDecoration(
            color: selected
                ? context.theme.colorScheme.surface.withTransparency
                : null,
            borderRadius: BorderRadius.circular(Spacing.d4 + Spacing.d2),
          ),
          child: Row(
            children: [
              SizedBox(width: Spacing.d8),
              if (expandable) ...[
                Tappable(
                  onTap: () {
                    onToggleExpand?.call();
                  },
                  child: expanded
                      ? ImageView(
                          Assets.icons.arrows.outline.directionDown01,
                          size: Spacing.d16,
                          color: context.theme.colorScheme.onBackground,
                        )
                      : ImageView(
                          Assets.icons.arrows.outline.directionRight01,
                          size: Spacing.d16,
                          color: context.theme.colorScheme.onBackground,
                        ),
                ),
                SizedBox(width: Spacing.d4),
              ],
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Spacing.d4,
                ),
                child: ImageView(
                  selected ? selectedIcon : icon,
                  size: Spacing.d20,
                  color: selected
                      ? context.theme.primaryColor
                      : context.theme.iconTheme.color,
                ),
              ),
              SizedBox(width: Spacing.d8),
              Expanded(
                child: Text(
                  title ?? uri?.lastNonEmptySegment ?? '',
                  style: (textStyle ?? context.theme.textTheme.bodyLarge)
                      ?.copyWith(
                    color: selected ? context.theme.primaryColor : null,
                    fontWeight: selected ? FontWeight.w700 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (selected)
                Container(
                  height: Spacing.d32,
                  width: Spacing.d4 + Spacing.d2,
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Spacing.d4 + Spacing.d2),
                      bottomRight: Radius.circular(Spacing.d4 + Spacing.d2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
