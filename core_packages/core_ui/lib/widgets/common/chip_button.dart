import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ChipButton extends Button {
  final String? text;

  const ChipButton({
    super.key,
    super.icon,
    this.text,
    super.tooltip,
    super.enable = true,
    super.enableHover = true,
    super.onPressed,
    super.semanticLabel,
    super.style = AppButtonStyle.chip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.d24,
      child: Button(
        style: style,
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        enable: enable,
        enableHover: enableHover,
        semanticLabel: semanticLabel,
        radius: Spacing.d4 + Spacing.d2,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.d8,
          vertical: Spacing.d2,
        ),
        child: Text(
          text ?? '',
          style: context.theme.textTheme.bodySmall,
        ),
      ),
    );
  }
}
