import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ListItem extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  final double? height;
  final double? radius;

  final EdgeInsets? padding;
  final EdgeInsets? titlePadding;
  final EdgeInsets? hoverOverlayPadding;

  final String? tooltip;

  final bool hideLeadingOnHandyDevice;
  final bool hideTitleOnHandyDevice;
  final bool hideTrailingOnHandyDevice;

  final FocusNode? focusNode;

  final ValueChanged<TappableState>? onStateChanged;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final HitTestBehavior? behavior;

  final bool isSelected;
  final bool expanded;

  final bool enableHover;
  final bool enableHoverOverlay;
  final bool enableAnimation;
  final bool enableFocusBorder;
  final bool enableFocus;

  final Color? backgroundColor;
  final Color? hoverOverlayColorTint;

  final MouseCursor mouseCursor;

  const ListItem({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.tooltip,
    this.height,
    this.radius,
    this.onStateChanged,
    this.onTap,
    this.onDoubleTap,
    this.behavior,
    this.hideLeadingOnHandyDevice = false,
    this.hideTitleOnHandyDevice = false,
    this.hideTrailingOnHandyDevice = false,
    this.isSelected = false,
    this.enableHover = true,
    this.enableHoverOverlay = true,
    this.enableAnimation = true,
    this.enableFocusBorder = true,
    this.enableFocus = false,
    this.focusNode,
    this.backgroundColor,
    this.hoverOverlayColorTint,
    this.padding,
    this.titlePadding,
    this.hoverOverlayPadding,
    this.expanded = true,
    this.mouseCursor = SystemMouseCursors.click,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = context.select((ThemeModel _) => _.screenSize);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Spacing.d0,
      ),
      child: Tappable(
        mouseCursor: mouseCursor,
        behavior: behavior,
        tooltip: tooltip,
        enableAnimation: enableAnimation,
        enableFocusBorder: enableFocusBorder,
        enableHover: enableHover,
        enableHoverOverlay: enableHoverOverlay,
        hoverOverlayPadding: hoverOverlayPadding,
        hoverOverlayBorderRadius: radius ?? Spacing.d8,
        hoverOverlayColorTint: hoverOverlayColorTint,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onStateChanged: onStateChanged,
        focusNode: focusNode,
        enableFocus: enableFocus,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? Spacing.d8),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (isSelected ? context.theme.cardColor : null),
            ),
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: Spacing.d20,
                  vertical: Spacing.d12,
                ),
            height: height,
            duration: FludaDuration.ms4,
            child: Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null &&
                    (!hideLeadingOnHandyDevice ||
                        (hideLeadingOnHandyDevice &&
                            !screenSize.isHandyDevice)))
                  SizedBox.square(
                    dimension: Spacing.d24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: (hoverOverlayColorTint != null && isSelected)
                            ? [
                                BoxShadow(
                                  color:
                                      hoverOverlayColorTint!.withOpacity(0.1),
                                  blurRadius: FludaX.x4,
                                  offset: const Offset(0.0, 2.0),
                                  spreadRadius: FludaX.x4,
                                ),
                                BoxShadow(
                                  color:
                                      hoverOverlayColorTint!.withOpacity(0.1),
                                  blurRadius: FludaX.x8,
                                  offset: const Offset(40.0, -40.0),
                                  spreadRadius: FludaX.x4,
                                ),
                              ]
                            : null,
                      ),
                      child: leading!,
                    ),
                  ),
                if (!hideTitleOnHandyDevice ||
                    (hideTitleOnHandyDevice && !screenSize.isHandyDevice))
                  expanded
                      ? Expanded(
                          child: Padding(
                            padding: titlePadding ??
                                EdgeInsets.only(
                                  left: Spacing.d20,
                                ),
                            child: title,
                          ),
                        )
                      : Padding(
                          padding: titlePadding ??
                              EdgeInsets.only(
                                left: Spacing.d20,
                              ),
                          child: title,
                        ),
                if (trailing != null &&
                    (!hideTrailingOnHandyDevice ||
                        (hideTrailingOnHandyDevice &&
                            !screenSize.isHandyDevice)))
                  trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
