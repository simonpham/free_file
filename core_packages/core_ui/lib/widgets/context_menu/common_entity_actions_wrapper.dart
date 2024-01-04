import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class CommonEntityActionsWrapper extends StatelessWidget {
  final Widget child;
  final Set<Entity> Function() selectedEntitiesGetter;
  final Set<Entity> Function() copiedEntitiesGetter;
  final List<Uri> Function() pinnedUrisGetter;

  final Function(EntityContextAction action)? onAction;

  const CommonEntityActionsWrapper({
    super.key,
    required this.selectedEntitiesGetter,
    required this.copiedEntitiesGetter,
    required this.pinnedUrisGetter,
    required this.child,
    this.onAction,
  });

  Widget _buildMenu(
    BuildContext context,
    bool isPressedAltOption,
    bool isPressedShift,
    bool isPressedControlCommand,
  ) {
    final selectedEntities = selectedEntitiesGetter.call();
    final copiedEntities = copiedEntitiesGetter.call();
    final pinnedUris = pinnedUrisGetter.call();
    return GenericContextMenu(
      buttonConfigs: [
        for (final action in EntityContextAction.getAvailableActions(
          selectedEntities: selectedEntities,
          copiedEntities: copiedEntities,
          isPressedAltOption: isPressedAltOption,
          isPressedShift: isPressedShift,
          isPressedControlCommand: isPressedControlCommand,
        ))
          ContextMenuButtonConfig(
            action.getLabel(
              context,
              selectedEntities,
              copiedEntities,
              pinnedUris,
            ),
            icon: action.icon == null
                ? SizedBox.square(dimension: Spacing.d16)
                : ImageView(
                    action.icon,
                    size: Spacing.d16,
                    color: context.theme.disabledColor,
                  ),
            shortcutLabel: action.shortcutLabel,
            onPressed: () {
              onAction?.call(action);
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyHoldDetector(
      onHoldChanged: (
        bool isPressedAltOption,
        bool isPressedShift,
        bool isPressedControlCommand,
      ) {
        if (!context.contextMenuOverlay.isShowing) {
          return;
        }
        context.contextMenuOverlay.show(
          _buildMenu(
            context,
            isPressedAltOption,
            isPressedShift,
            isPressedControlCommand,
          ),
        );
      },
      child: Listener(
        onPointerDown: (event) {
          if (event.buttons != kSecondaryMouseButton) {
            return;
          }
          if (context.contextMenuOverlay.isShowing) {
            return;
          }
          context.contextMenuOverlay.show(
            _buildMenu(
              context,
              false,
              false,
              false,
            ),
          );
        },
        child: child,
      ),
    );
  }
}
