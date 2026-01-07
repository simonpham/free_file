import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:storage/data/data.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ToolBar extends StatelessWidget {
  final Function(EntityContextAction action)? onAction;

  const ToolBar({super.key, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d36,
      decoration: BoxDecoration(
        color: context.appTheme.color.navBarBackground.withTransparency,
        border: Border(
          bottom: BorderSide(
            color: context.appTheme.color.disabledIconColor.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: KeyHoldDetectorBuilder(
        builder:
            (
              BuildContext context,
              bool isPressedAltOption,
              bool isPressedShift,
              bool isPressedControlCommand,
            ) {
              return Consumer2<TabViewModel, ExploreViewModel>(
                builder: (context, tabModel, exploreModel, _) {
                  final selectedEntities = exploreModel.selectedEntities;
                  final copiedEntities = tabModel.copiedEntities;
                  return ChangeNotifierProvider.value(
                    value: exploreModel.sideBarViewModel,
                    child: Consumer<SideBarViewModel>(
                      builder: (BuildContext context, _, __) {
                        return Row(
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Spacing.d12,
                                ),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (final action
                                      in EntityContextAction.getAvailableActions(
                                        selectedEntities: selectedEntities,
                                        copiedEntities: copiedEntities,
                                        isPressedAltOption: isPressedAltOption,
                                        isPressedShift: isPressedShift,
                                        isPressedControlCommand:
                                            isPressedControlCommand,
                                      )) ...[
                                    Tappable(
                                      key: ValueKey(action),
                                      tooltip: action.isCompact
                                          ? action.getLabel(
                                              context,
                                              selectedEntities:
                                                  selectedEntities,
                                              copiedEntities: copiedEntities,
                                              pinnedUris: Settings().pinnedUris,
                                              currentUri: tabModel
                                                  .currentExploreViewModel
                                                  .currentUri,
                                            )
                                          : null,
                                      enableHover: true,
                                      enableHoverOverlay: true,
                                      hoverOverlayBorderRadius: Spacing.d8,
                                      hoverOverlayPadding: EdgeInsets.symmetric(
                                        vertical: Spacing.d4,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: Spacing.d4,
                                          horizontal: Spacing.d8,
                                        ),
                                        height: Spacing.d36,
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            if (action.icon != null)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: action.isCompact
                                                      ? 0.0
                                                      : Spacing.d4,
                                                ),
                                                child: ImageView(
                                                  action.icon,
                                                  size: Spacing.d16,
                                                  color: context
                                                      .appTheme
                                                      .color
                                                      .iconColor,
                                                ),
                                              ),
                                            if (!action.isCompact)
                                              Text(
                                                action.getLabel(
                                                  context,
                                                  selectedEntities:
                                                      selectedEntities,
                                                  copiedEntities:
                                                      copiedEntities,
                                                  pinnedUris:
                                                      Settings().pinnedUris,
                                                  currentUri: tabModel
                                                      .currentExploreViewModel
                                                      .currentUri,
                                                ),
                                                style: context
                                                    .theme
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        onAction?.call(action);
                                      },
                                    ),
                                    SizedBox(width: Spacing.d4),
                                  ],
                                ],
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              indent: Spacing.d8,
                              endIndent: Spacing.d8,
                              color: context.appTheme.color.disabledIconColor
                                  .withValues(alpha: .2),
                            ),
                            SizedBox(width: Spacing.d8),
                            _ViewModeSelector(
                              currentMode: exploreModel.viewMode,
                              onModeChanged: (mode) {
                                exploreModel.viewMode = mode;
                              },
                            ),
                            SizedBox(width: Spacing.d12),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
      ),
    );
  }
}

class _ViewModeSelector extends StatelessWidget {
  final ViewMode currentMode;
  final ValueChanged<ViewMode> onModeChanged;

  const _ViewModeSelector({
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final mode in ViewMode.values) ...[
          Tappable(
            tooltip: mode.name,
            enableHover: true,
            enableHoverOverlay: true,
            hoverOverlayBorderRadius: Spacing.d4,
            hoverOverlayPadding: EdgeInsets.zero,
            onTap: () => onModeChanged(mode),
            child: Container(
              width: Spacing.d28,
              height: Spacing.d28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: currentMode == mode
                    ? context.appTheme.color.primary.withValues(alpha: .1)
                    : null,
                borderRadius: BorderRadius.circular(Spacing.d4),
              ),
              child: ImageView(
                mode.icon,
                size: Spacing.d16,
                color: currentMode == mode
                    ? context.appTheme.color.primary
                    : context.appTheme.color.iconColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

extension on ViewMode {
  SvgGenImage get icon {
    switch (this) {
      case ViewMode.list:
        return Assets.icons.interface.outline.listViewRectangle;
      case ViewMode.grid:
        return Assets.icons.grid.outline.grid;
      case ViewMode.details:
        return Assets.icons.editor.outline.table;
      // case ViewMode.columns:
      //   return Assets.icons.grid.outline.layout03;
    }
  }
}
