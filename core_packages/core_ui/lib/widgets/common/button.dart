import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  label,
  chip,
  danger,
  success,
  warning,
  link,
}

class Button extends StatelessWidget {
  final AppButtonStyle style;

  final Function? onPressed;

  final Widget? icon;
  final Widget? child;
  final Widget? trailingIcon;

  final Color? color;

  final bool enable;
  final bool enableHover;

  final bool expandTitle;

  final String? tooltip;
  final String? semanticLabel;

  final double? width;
  final double? height;
  final double? borderWidth;
  final double? radius;

  final EdgeInsets? padding;

  final MainAxisSize? mainAxisSize;
  final MainAxisAlignment? mainAxisAlignment;

  const Button({
    super.key,
    required this.style,
    this.icon,
    this.trailingIcon,
    this.color,
    this.tooltip,
    this.enable = true,
    this.enableHover = true,
    this.expandTitle = true,
    this.onPressed,
    this.child,
    this.semanticLabel,
    this.width,
    this.height,
    this.borderWidth,
    this.radius,
    this.padding,
    this.mainAxisSize,
    this.mainAxisAlignment,
  });

  factory Button.primary({
    Function? onPressed,
    Widget? icon,
    String? text,
    bool enable = true,
    bool enableHover = true,
    String? tooltip,
    String? semanticLabel,
  }) =>
      PrimaryButton(
        style: AppButtonStyle.primary,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        text: text,
        semanticLabel: semanticLabel,
      );

  factory Button.secondary({
    Function? onPressed,
    Widget? icon,
    String? text,
    bool enable = true,
    bool enableHover = true,
    String? tooltip,
    String? semanticLabel,
  }) =>
      SecondaryButton(
        style: AppButtonStyle.secondary,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        text: text,
        semanticLabel: semanticLabel,
      );

  factory Button.outline({
    Function? onPressed,
    Widget? icon,
    String? text,
    bool enable = true,
    bool enableHover = true,
    String? tooltip,
    String? semanticLabel,
  }) =>
      OutlineButton(
        style: AppButtonStyle.outline,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        text: text,
        semanticLabel: semanticLabel,
      );

  factory Button.text({
    Function? onPressed,
    Widget? icon,
    String? text,
    bool enable = true,
    bool enableHover = true,
    String? tooltip,
    String? semanticLabel,
  }) =>
      LabelButton(
        style: AppButtonStyle.label,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        text: text,
        semanticLabel: semanticLabel,
      );

  factory Button.chip({
    Function? onPressed,
    Widget? icon,
    String? text,
    bool enable = true,
    bool enableHover = true,
    String? tooltip,
    String? semanticLabel,
  }) =>
      ChipButton(
        style: AppButtonStyle.chip,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        text: text,
        semanticLabel: semanticLabel,
      );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? tooltip,
      button: true,
      enabled: enable,
      child: Tappable(
        tooltip: tooltip,
        onTap: enable ? () => onPressed?.call() : null,
        enableHover: enableHover,
        hoverOverlayBorderRadius: radius ?? Spacing.d12,
        hoverOverlayColorTint: color ?? _getButtonColor(context),
        child: AnimatedContainer(
          width: width,
          height: height,
          duration: FludaDuration.ms4,
          curve: Curves.easeOut,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: Spacing.d24,
                vertical: Spacing.d12,
              ),
          decoration: BoxDecoration(
            color: color ?? _getButtonColor(context),
            borderRadius: BorderRadius.circular(radius ?? Spacing.d12),
            border: Border.all(
              color: _getBorderColor(context),
              width: borderWidth ?? Spacing.d2,
            ),
          ),
          child: Row(
            mainAxisSize: mainAxisSize ?? MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null && child != null)
                SizedBox(
                  width: Spacing.d8,
                ),
              if (child != null && trailingIcon != null && expandTitle)
                Expanded(
                  child: child!,
                ),
              if (child != null && trailingIcon != null && !expandTitle) child!,
              if (child != null && trailingIcon == null) child!,
              if (trailingIcon != null) ...[
                SizedBox(
                  width: Spacing.d8,
                ),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(BuildContext context) {
    var color = this.color;

    switch (style) {
      case AppButtonStyle.primary:
      case AppButtonStyle.label:
      case AppButtonStyle.danger:
        return Colors.transparent;
      case AppButtonStyle.secondary:
        color = context.theme.primaryColor;
        break;
      case AppButtonStyle.outline:
      default:
        color = context.dividerColor;
        break;
    }

    if (!enable) {
      color = color.withOpacity(0.5);
    }

    return color;
  }

  Color? _getButtonColor(BuildContext context) {
    var color = this.color;

    switch (style) {
      case AppButtonStyle.primary:
        color = context.theme.colorScheme.primary;
        break;
      case AppButtonStyle.chip:
        final isDark = ThemeConfigs().themeMode == ThemeMode.dark;
        color = isDark ? kNeutralSwatch[7]! : kNeutralSwatch[3]!;
        break;
      case AppButtonStyle.danger:
        color = context.theme.colorScheme.error;
        break;
      case AppButtonStyle.secondary:
      case AppButtonStyle.outline:
      case AppButtonStyle.label:
        return Colors.transparent;
      default:
        color ??= context.theme.colorScheme.surface;
        break;
    }

    if (!enable) {
      color = color.withOpacity(0.5);
    }

    return color;
  }
}
