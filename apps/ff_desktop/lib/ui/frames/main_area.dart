import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:utils/utils.dart';

class MainArea extends StatelessWidget {
  const MainArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surface,
      child: Selector<ExploreViewModel, List<Entity>>(
        selector: (BuildContext context, ExploreViewModel model) {
          return model.entities;
        },
        builder: (context, entities, _) {
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (BuildContext context, int index) {
              final entity = entities[index];
              return InkWell(
                onDoubleTap: () {
                  if (entity is Directory) {
                    final model = context.read<ExploreViewModel>();
                    model.goTo(entity.path);
                  }
                },
                child: ListTile(
                  leading: Icon(
                    entity.entityIcon,
                  ),
                  title: Text(entity.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
