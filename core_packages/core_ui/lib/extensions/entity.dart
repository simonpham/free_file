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

  Color getEntityColor(AppTheme appTheme) {
    final color = switch (type) {
      EntityType.directory => appTheme.color.primary,
      EntityType.file => appTheme.color.iconColor,
    };
    return hiddenStatus.isHidden ? color.withOpacity(0.6) : color;
  }
}
