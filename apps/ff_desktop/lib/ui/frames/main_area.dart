import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/models/models.dart';
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
          final (viewMode, entities, selectedEntities) = data;
          return EntityView(
            scrollController: scrollController,
            mode: viewMode,
            entities: entities,
            selectedEntities: selectedEntities,
            onSelectionChanged: (selectedEntities) {
              context.read<ExploreViewModel>().selectBatch(selectedEntities);
            },
            onEntityTap: (entity) {
              entity.tap(context);
            },
            onEntityDoubleTap: (entity) {
              entity.doubleTap(context);
            },
            onAction: (action) {
              final selectedEntities = context
                  .read<ExploreViewModel>()
                  .selectedEntities
                  .toSet();
              _handleAction(context, action, selectedEntities);
            },
          );
        },
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    EntityContextAction action,
    Set<Entity> entities,
  ) {
    switch (action) {
      case EntityContextAction.open:
        for (final entity in entities) {
          if (entity is Directory) {
            entity.openInNewTab(context);
          }
          if (entity is File) {
            entity.doubleTap(context);
          }
        }
        break;
      case EntityContextAction.openInNewWindow:
        break;
      case EntityContextAction.openInNewTab:
        for (final entity in entities) {
          if (entity is Directory) {
            entity.openInNewTab(context);
          }
        }
        break;
      case EntityContextAction.quickLook:
        context.read<TabViewModel>().quickLook(entities: entities);
        break;
      case EntityContextAction.compress:
        context.read<TabViewModel>().compress(entities: entities);
        break;
      case EntityContextAction.copy:
        context.read<TabViewModel>().copy(entities: entities);
        break;
      case EntityContextAction.paste:
        context.read<TabViewModel>().paste();
        break;
      case EntityContextAction.move:
        break;
      case EntityContextAction.delete:
        break;
      case EntityContextAction.deletePermanently:
        break;
      case EntityContextAction.rename:
        break;
      case EntityContextAction.properties:
        break;
      case EntityContextAction.unknown:
      default:
        break;
    }
  }
}
