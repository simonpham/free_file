import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:theme/theme.dart';

part 'view_modes/list.dart';

class EntityView extends StatelessWidget {
  final List<Entity> entities;
  final ViewMode mode;

  const EntityView({
    super.key,
    required this.entities,
    this.mode = ViewMode.list,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ViewMode.columns:
      case ViewMode.details:
      case ViewMode.grid:
      case ViewMode.list:
      default:
        return EntityViewList(entities: entities);
    }
  }
}
