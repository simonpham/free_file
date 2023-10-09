import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class SecondaryButton extends Button {
  final String? text;

  const SecondaryButton({
    super.key,
    super.icon,
    this.text,
    super.tooltip,
    super.enable = true,
    super.enableHover = true,
    super.onPressed,
    super.semanticLabel,
    super.style = AppButtonStyle.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      style: style,
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
      enable: enable,
      enableHover: enableHover,
      semanticLabel: semanticLabel,
      child: Text(
        text ?? '',
        style: context.theme.textTheme.bodySmall,
      ),
    );
  }
}
