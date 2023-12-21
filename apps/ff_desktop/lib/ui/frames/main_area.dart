import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/utils/entity_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class MainArea extends StatefulWidget {
  final Function(EntityContextAction action)? onAction;

  const MainArea({
    super.key,
    this.onAction,
  });

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  final ScrollController scrollController = ScrollController();

  Set<Entity> selectedEntitiesGetter() =>
      context.read<ExploreViewModel>().selectedEntities.toSet();

  Set<Entity> copiedEntitiesGetter() =>
      context.read<TabViewModel>().copiedEntities.toSet();

  bool _isPressedShift = false;
  bool _isPressedControlCommand = false;

  @override
  Widget build(BuildContext context) {
    return KeyHoldDetector(
      onHoldChanged: (_, bool isPressedShift, bool isPressedControlCommand) {
        _isPressedShift = isPressedShift;
        _isPressedControlCommand = isPressedControlCommand;
      },
      child: Container(
        color: context.appTheme.color.mainBackground.withTransparency,
        child: Selector<ExploreViewModel, (ViewMode, List<Entity>)>(
          selector: (BuildContext context, ExploreViewModel model) {
            return (model.viewMode, model.entities);
          },
          builder: (context, data, _) {
            final (viewMode, entities) = data;
            final textController =
                context.select((ExploreViewModel _) => _.entityNameController);
            return EntityView(
              scrollController: scrollController,
              mode: viewMode,
              entities: entities,
              selectedEntitiesGetter: selectedEntitiesGetter,
              copiedEntitiesGetter: copiedEntitiesGetter,
              isRenaming: context.select((ExploreViewModel _) => _.isRenaming),
              entityNameFocusNode:
                  context.select((ExploreViewModel _) => _.entityNameFocusNode),
              entityNameController: textController,
              onRenameFinished: () {
                final newName = textController.text;
                final selectedEntities = selectedEntitiesGetter();
                context.read<ExploreViewModel>().finishRename(
                      entities: selectedEntities,
                      newName: newName,
                    );
              },
              onSelectionChanged: (selectedEntities) {
                context.read<ExploreViewModel>().selectBatch(selectedEntities);
              },
              onEntityTap: (entity) {
                printLog('onEntityTap: ($_isPressedShift) ${entity.path}');
                entity.tap(
                  context,
                  isPressedShift: _isPressedShift,
                  isPressedControlCommand: _isPressedControlCommand,
                );
              },
              onEntityDoubleTap: (entity) {
                entity.doubleTap(context);
              },
              onAction: widget.onAction,
            );
          },
        ),
      ),
    );
  }
}
