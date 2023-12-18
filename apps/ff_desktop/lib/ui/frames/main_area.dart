import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:ff_desktop/utils/entity_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appTheme.color.mainBackground.withTransparency,
      child: Selector<ExploreViewModel, (ViewMode, List<Entity>)>(
        selector: (BuildContext context, ExploreViewModel model) {
          return (model.viewMode, model.entities);
        },
        builder: (context, data, _) {
          final (viewMode, entities) = data;
          return EntityView(
            scrollController: scrollController,
            mode: viewMode,
            entities: entities,
            selectedEntitiesGetter: selectedEntitiesGetter,
            copiedEntitiesGetter: copiedEntitiesGetter,
            onSelectionChanged: (selectedEntities) {
              context.read<ExploreViewModel>().selectBatch(selectedEntities);
            },
            onEntityTap: (entity) {
              entity.tap(context);
            },
            onEntityDoubleTap: (entity) {
              entity.doubleTap(context);
            },
            onAction: widget.onAction,
          );
        },
      ),
    );
  }
}
