import 'package:core/models/models.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

extension EntityExtension on Entity {
  SvgGenImage get entityIcon {
    switch (type) {
      case EntityType.directory:
        final directory = this as Directory;
        return directory.icon;
      case EntityType.file:
        final file = this as File;
        return file.icon;
    }
  }

  Color getEntityColor(BuildContext context) {
    final color = switch (type) {
      EntityType.directory => context.appTheme.color.primary,
      EntityType.file => context.appTheme.color.iconColor,
    };
    return isHidden ? color.withOpacity(0.6) : color;
  }
}
