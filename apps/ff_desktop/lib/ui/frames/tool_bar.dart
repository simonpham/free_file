import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ToolBar extends StatelessWidget {
  final Function(EntityContextAction action)? onAction;

  const ToolBar({
    super.key,
    this.onAction,
  });

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
        builder: (BuildContext context, bool isPressedAltOption,
            bool isPressedShift, bool isPressedControlCommand) {
          return Consumer2<TabViewModel, ExploreViewModel>(
            builder: (context, tabModel, exploreModel, _) {
              final selectedEntities = exploreModel.selectedEntities;
              final copiedEntities = tabModel.copiedEntities;
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d12,
                ),
                scrollDirection: Axis.horizontal,
                children: [
                  for (final action in EntityContextAction.getAvailableActions(
                    selectedEntities: selectedEntities,
                    copiedEntities: copiedEntities,
                    isPressedAltOption: isPressedAltOption,
                    isPressedShift: isPressedShift,
                    isPressedControlCommand: isPressedControlCommand,
                  )) ...[
                    Tappable(
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
                                  right: action.isCompact ? 0.0 : Spacing.d4,
                                ),
                                child: ImageView(
                                  action.icon,
                                  size: Spacing.d16,
                                  color: context.appTheme.color.iconColor,
                                ),
                              ),
                            if (!action.isCompact)
                              Text(
                                action.getLabel(
                                  context,
                                  selectedEntities,
                                  copiedEntities,
                                ),
                                style: context.theme.textTheme.bodySmall,
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
              );
            },
          );
        },
      ),
    );
  }
}
