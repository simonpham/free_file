import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class DropdownPopups {
  static (RelativeRect, Size) _getDropdownPosition(BuildContext context) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Offset topLeft = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final boxSize = box?.size ?? Size.zero;
    return (
      RelativeRect.fromLTRB(
        topLeft.dx,
        topLeft.dy + boxSize.height + Spacing.d8,
        topLeft.dx + boxSize.width,
        topLeft.dy + boxSize.height,
      ),
      boxSize,
    );
  }

  static Color? _getMenuBackgroundColor(BuildContext context, bool isDark) {
    return context.theme.popupMenuTheme.color;
  }
}
