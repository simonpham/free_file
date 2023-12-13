import 'dart:async';

import 'package:core/core.dart';
import 'package:ff_desktop/interfaces/interfaces.dart';
import 'package:flutter/foundation.dart';
import 'package:ff_desktop/features/features.dart';
import 'package:flutter/material.dart';
import 'package:local_entity_provider/local_entity_provider.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:utils/utils.dart';

mixin WorkspaceCopyPasteMixin on ChangeNotifier
    implements WorkspaceInterfaceCommands {
  ExploreViewModel get currentExploreViewModel;

  LocalEntityProvider get _local => injector.get<LocalEntityProvider>();

  Set<Entity> _copiedEntities = {};

  Future<List<String>> get _copiedPaths {
    return Pasteboard.files();
  }

  @override
  Future<void> copy({Set<Entity>? entities}) async {
    _copiedEntities = entities ?? currentExploreViewModel.selectedEntities;
    await Pasteboard.writeFiles(
      _copiedEntities.map((e) => e.path.toFilePath()).toList(),
    );
    notifyListeners();
  }

  @override
  Future<void> paste({Uri? path}) async {
    if (_copiedEntities.isEmpty) {
      return;
    }

    path ??= currentExploreViewModel.currentUri;

    final copiedPaths = await _copiedPaths;
    if (copiedPaths.isEmpty) {
      return;
    }

    final List<String> pathToSelects = [];
    for (var copiedPath in copiedPaths) {
      final copiedEntity = _copiedEntities.firstWhere(
        (item) => item.path.toFilePath() == copiedPath,
      );
      final newPath = path.resolve(path.path + kSlash + copiedEntity.name);
      if (copiedEntity is File) {
        await _local.copyFile(copiedEntity.path, newPath);
      } else if (copiedEntity is Directory) {
        await _local.copyDirectory(copiedEntity.path, newPath);
      }

      pathToSelects.add(newPath.toFilePath());
    }

    await Pasteboard.writeFiles(const []);
    _copiedEntities = {};
    await currentExploreViewModel.refresh();
    currentExploreViewModel.selectBatch(currentExploreViewModel.entities
        .where((item) => pathToSelects.contains(item.path.toFilePath()))
        .toSet());
  }

  Future<void> refreshClipboard() async {
    final copiedPaths = await Pasteboard.files();
    printLog('[TabViewModel] refreshClipboard: $copiedPaths');
    if (copiedPaths.isEmpty) {
      return;
    }

    final List<Entity> copiedEntities = [];
    for (var copiedPath in copiedPaths) {
      try {
        final uri = Uri.parse(copiedPath);
        final copiedEntity = await _local.get(uri);
        if (copiedEntity == null) {
          continue;
        }
        copiedEntities.add(copiedEntity);
      } catch (err, trace) {
        printError(err, trace);
      }
    }
    _copiedEntities = copiedEntities.toSet();
    notifyListeners();
  }
}
