import 'dart:async';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class CommonEntityActionsWrapper extends StatelessWidget {
  final Widget child;
  final Entity entity;

  final FutureOr<Directory> Function(Uri path, Uri newPath)? onCopyDirectory;
  final FutureOr<Directory> Function(Uri path)? onCreateDirectory;
  final FutureOr<void> Function(Uri path)? onDeleteDirectory;
  final bool Function(Directory directory)? hasSubDirectoriesCheck;
  final FutureOr<Directory> Function(Uri path, Uri newPath)? onMoveDirectory;

  final FutureOr<File> Function(Uri path, Uri newPath)? onCopyFile;
  final FutureOr<File> Function(Uri path)? onCreateFile;
  final FutureOr<void> Function(Uri path)? onDeleteFile;
  final FutureOr<File> Function(Uri path, Uri newPath)? onMoveFile;

  const CommonEntityActionsWrapper({
    super.key,
    required this.entity,
    required this.child,
    this.onCopyDirectory,
    this.onCreateDirectory,
    this.onDeleteDirectory,
    this.hasSubDirectoriesCheck,
    this.onMoveDirectory,
    this.onCopyFile,
    this.onCreateFile,
    this.onDeleteFile,
    this.onMoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return KeyHoldDetector(
      builder: (
        BuildContext context,
        bool isPressedAltOption,
        bool isPressedShift,
        bool isPressedControlCommand,
      ) {
        return ContextMenuRegion(
          contextMenu: GenericContextMenu(
            buttonConfigs: [
              for (final action in EntityContextAction.getAvailableActions(
                isPressedAltOption: isPressedAltOption,
                isPressedShift: isPressedShift,
                isPressedControlCommand: isPressedControlCommand,
              ))
                ContextMenuButtonConfig(
                  action.getLabel(context),
                  icon: action.icon == null
                      ? SizedBox.square(dimension: Spacing.d16)
                      : ImageView(
                          action.icon,
                          size: Spacing.d16,
                          color: context.theme.disabledColor,
                        ),
                  shortcutLabel: action.shortcutLabel,
                  onPressed: () {
                    switch (action) {
                      case EntityContextAction.copy:
                        _handleCopy();
                        break;
                      case EntityContextAction.paste:
                        _handlePaste();
                        break;
                      case EntityContextAction.move:
                        _handleMove();
                        break;
                      case EntityContextAction.properties:
                        _handleProperties();
                        break;
                      default:
                        break;
                    }
                  },
                ),
            ],
          ),
          child: child,
        );
      },
    );
  }

  void _handleMove() {}

  void _handleCopy() {
    switch (entity.type) {
      case EntityType.directory:
        final directory = entity as Directory;
        onCopyDirectory?.call(directory.path, directory.path);
        break;
      case EntityType.file:
        final file = entity as File;
        onCopyFile?.call(file.path, file.path);
        break;
    }
  }

  void _handlePaste() {}

  void _handleProperties() {}
}
