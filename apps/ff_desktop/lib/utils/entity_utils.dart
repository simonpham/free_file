import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';

extension EntityUtilsExtension on Entity {
  Future<void> tap(BuildContext context) async {
    final model = context.read<ExploreViewModel>();
    model.select(this);
  }

  Future<void> doubleTap(BuildContext context) async {
    final model = context.read<ExploreViewModel>();
    model.goTo(path);
  }
}
