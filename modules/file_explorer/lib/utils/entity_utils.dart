import 'dart:async';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:file_explorer/view_models/view_models.dart';
import 'package:flutter/material.dart';

extension EntityUtilsExtension on Entity {
  Future<void> tap(
    BuildContext context, {
    bool isPressedShift = false,
    bool isPressedControlCommand = false,
  }) async {
    final model = context.read<ExploreViewModel>();
    model.select(
      this,
      isPressedShift: isPressedShift,
      isPressedControlCommand: isPressedControlCommand,
    );
  }

  Future<void> doubleTap(BuildContext context) async {
    final model = context.read<ExploreViewModel>();
    unawaited(model.goTo(path));
  }
}

extension DirectoryUtilsExtension on Directory {
  Future<void> openInNewTab(BuildContext context) async {
    final model = context.read<TabViewModel>();
    final newTab = ExploreViewModel();
    unawaited(newTab.goTo(path));
    model.addTab(newTab);
  }
}
