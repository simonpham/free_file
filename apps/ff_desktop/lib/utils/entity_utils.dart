import 'package:core/core.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ff_desktop/features/features.dart';

extension EntityUtilsExtension on Entity {
  Future<void> doubleTap(BuildContext context) async {
    final model = context.read<ExploreViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (this is Directory) {
      model.goTo(path);
    } else {
      final error = await PlatformUtils.open(
        path,
        workingDirectory: model.currentUri,
      );
      if (error != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              error.toReadableMessage(),
            ),
          ),
        );
      }
    }
  }
}
