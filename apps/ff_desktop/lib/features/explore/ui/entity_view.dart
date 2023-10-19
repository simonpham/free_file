import 'dart:math';

import 'package:ff_desktop/ui/ui.dart';
import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

part 'view_modes/list.dart';

class EntityView extends StatelessWidget {
  final ScrollController scrollController;
  final List<Entity> entities;
  final ViewMode mode;

  const EntityView({
    super.key,
    required this.scrollController,
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
        return EntityViewList(
          scrollController: scrollController,
          entities: entities,
        );
    }
  }
}
