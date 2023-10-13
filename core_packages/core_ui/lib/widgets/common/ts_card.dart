import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class TsCard extends StatelessWidget {
  final Widget? child;
  final double? radius;
  final double? borderSize;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final BoxConstraints? constraints;
  final bool flatten;
  final bool enableBorder;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final double additionElevation;

  const TsCard({
    Key? key,
    this.child,
    this.radius,
    this.borderSize,
    this.color,
    this.borderColor,
    this.gradient,
    this.constraints,
    this.flatten = false,
    this.enableBorder = false,
    this.margin = const EdgeInsets.all(FludaX.x),
    this.padding,
    this.additionElevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return AnimatedContainer(
      duration: FludaDuration.ms2,
      curve: Curves.easeOut,
      constraints: constraints,
      margin: flatten ? EdgeInsets.zero : margin,
      decoration: BoxDecoration(
        color: gradient != null ? null : (color ?? context.theme.cardColor),
        gradient: gradient,
        borderRadius: flatten
            ? null
            : BorderRadius.circular(
                radius ?? Spacing.d12,
              ),
        border: enableBorder
            ? Border.all(
                color:
                    borderColor ?? context.theme.dividerColor.withOpacity(0.1),
                width: borderSize ?? Spacing.d2,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
        boxShadow: flatten || isDark
            ? null
            : [
                BoxShadow(
                  offset: Offset(
                    Spacing.d4 + Spacing.d2,
                    Spacing.d4 + Spacing.d2,
                  ),
                  blurRadius: (additionElevation * Spacing.d1) + Spacing.d24,
                  spreadRadius: additionElevation + 0.0,
                  color: const Color(0xff17271B)
                      .withOpacity(0.03 + 0.03 * additionElevation),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          flatten ? 0.0 : radius ?? Spacing.d12,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
