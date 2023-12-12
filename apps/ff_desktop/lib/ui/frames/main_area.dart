import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/entity_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';

class MainArea extends StatefulWidget {
  const MainArea({
    super.key,
  });

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appTheme.color.mainBackground.withTransparency,
      child: Selector<ExploreViewModel, (ViewMode, List<Entity>, Set<Entity>)>(
        selector: (BuildContext context, ExploreViewModel model) {
          return (model.viewMode, model.entities, model.selectedEntities);
        },
        builder: (context, data, _) {
          return EntityView(
            scrollController: scrollController,
            mode: data.$1,
            entities: data.$2,
            selectedEntities: data.$3,
            onSelectionChanged: (selectedEntities) {
              context.read<ExploreViewModel>().selectBatch(selectedEntities);
            },
            onEntityTap: (entity) {
              entity.tap(context);
            },
            onEntityDoubleTap: (entity) {
              entity.doubleTap(context);
            },
            onOpenEntityInNewTab: (entity) {
              entity.openInNewTab(context);
            },
          );
        },
      ),
    );
  }
}
