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

  static bool hasTextOverflow(
    String text,
    TextStyle style, {
    double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 1,
  }) {
    try {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: minWidth, maxWidth: maxWidth);
      return textPainter.didExceedMaxLines;
    } catch (_) {
      return true;
    }
  }

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
    final isHoverNotifier = ValueNotifier<bool>(false);
    return Container(
      margin: EdgeInsets.only(
        left: Spacing.d8,
      ),
      child: MouseRegion(
        onEnter: (event) {
          isHoverNotifier.value = true;
        },
        onExit: (event) {
          isHoverNotifier.value = false;
        },
        child: Tappable(
          enableAnimation: false,
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          child: ValueListenableBuilder(
              valueListenable: isHoverNotifier,
              builder: (context, isHover, _) {
                return Container(
                  padding: EdgeInsets.only(
                    left: level * Spacing.d8 + (expandable ? 0.0 : Spacing.d20),
                  ),
                  decoration: BoxDecoration(
                    color: isHover
                        ? context.theme.colorScheme.surface
                        : (selected
                            ? context.theme.colorScheme.surface.withTransparency
                            : null),
                    borderRadius:
                        BorderRadius.circular(Spacing.d4 + Spacing.d2),
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
                        child: LayoutBuilder(
                          builder: (context, constraint) {
                            final text =
                                title ?? uri?.lastNonEmptySegment ?? '';
                            final textStyle = this.textStyle ??
                                (context.theme.textTheme.bodyLarge ??
                                        const TextStyle())
                                    .copyWith(
                                  color: selected
                                      ? context.theme.primaryColor
                                      : context.theme.colorScheme.onBackground,
                                  fontWeight: selected ? FontWeight.w700 : null,
                                );
                            final hasTextOverflow = SideBarItem.hasTextOverflow(
                              text,
                              textStyle,
                              minWidth: 0,
                              maxWidth: constraint.maxWidth - Spacing.d20,
                            );
                            return SideBarItemHover(
                              enabled: hasTextOverflow,
                              selected: selected,
                              text: text,
                              textStyle: textStyle,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: Spacing.d32,
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                        right: Spacing.d4,
                                      ),
                                      child: Text(
                                        text,
                                        style: textStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  if ((isHover || selected) && !hasTextOverflow)
                                    Container(
                                      height: Spacing.d32,
                                      width: Spacing.d4 + Spacing.d2,
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                              Spacing.d4 + Spacing.d2),
                                          bottomRight: Radius.circular(
                                              Spacing.d4 + Spacing.d2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class SideBarItemHover extends StatefulWidget {
  final bool enabled;
  final bool selected;

  final Widget child;

  final String text;
  final TextStyle textStyle;

  const SideBarItemHover({
    super.key,
    required this.enabled,
    required this.selected,
    required this.child,
    required this.text,
    required this.textStyle,
  });

  @override
  State<SideBarItemHover> createState() => _SideBarItemHoverState();
}

class _SideBarItemHoverState extends State<SideBarItemHover> {
  static const String _overlayDebounceKey = 'side_bar_item_hover';

  OverlayEntry? _overlayEntry;

  void _hideOverlay(BuildContext context) {
    EasyDebounce.cancel(_overlayDebounceKey);
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay(BuildContext context, Offset? globalPosition, Size? size) {
    if (_overlayEntry != null) {
      return;
    }
    if (globalPosition == null || size == null) {
      return;
    }
    final overlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: globalPosition.dx,
          top: globalPosition.dy,
          height: size.height,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(Spacing.d4 + Spacing.d2),
              ),
              child: Row(
                children: [
                  Container(
                    height: Spacing.d32,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      right: Spacing.d16,
                    ),
                    child: Text(
                      widget.text,
                      style: widget.textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
      },
    );
    _overlayEntry = overlay;
    Overlay.of(context).insert(overlay);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        if (!widget.enabled) {
          return;
        }
        EasyDebounce.debounce(
          _overlayDebounceKey,
          const Duration(milliseconds: 100),
          () {
            final renderObject = context.findRenderObject() as RenderBox?;
            final globalPosition = renderObject?.localToGlobal(Offset.zero);
            final size = renderObject?.size;
            _showOverlay(context, globalPosition, size);
          },
        );
      },
      onExit: (event) {
        if (!widget.enabled) {
          return;
        }
        _hideOverlay(context);
      },
      child: widget.child,
    );
  }
}
