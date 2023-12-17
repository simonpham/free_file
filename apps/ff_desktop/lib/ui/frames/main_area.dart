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
            onAction: (action) {
              _handleAction(context, action);
            },
          );
        },
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    EntityContextAction action,
  ) {
    final entities = selectedEntitiesGetter.call();
    if (entities.isEmpty) {
      /// If no entities are selected, open current directory in new tab.
      final model = context.read<TabViewModel>();
      final newTab = ExploreViewModel();
      newTab.goTo(model.currentExploreViewModel.currentUri);
      model.addTab(newTab);
      return;
    }

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
        context.read<TabViewModel>().move();
        break;
      case EntityContextAction.delete:
        context.read<ExploreViewModel>().delete(entities: entities);
        break;
      case EntityContextAction.deletePermanently:
        context.read<ExploreViewModel>().deletePermanently(entities: entities);
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
