import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/explore/ui/ui.dart';
import 'package:theme/theme.dart';

class EntityIconWidget extends StatelessWidget {
  final Entity entity;
  final double size;

  const EntityIconWidget({
    super.key,
    required this.entity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final entity = this.entity;
    if (entity is File && kThumbnailSupportedTypes.contains(entity.fileType)) {
      return ThumbnailWidget(
        file: entity,
        size: size,
      );
    }

    return ImageView(
      entity.entityIcon,
      color: entity.getEntityColor(context.appTheme),
      size: size,
    );
  }
}
