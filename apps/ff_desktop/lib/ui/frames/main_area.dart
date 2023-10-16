import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';

class MainArea extends StatelessWidget {
  const MainArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appTheme.color.mainBackground.withTransparency,
      child: Selector<ExploreViewModel, List<Entity>>(
        selector: (BuildContext context, ExploreViewModel model) {
          return model.entities;
        },
        builder: (context, entities, _) {
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (BuildContext context, int index) {
              final entity = entities[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.d8,
                  vertical: Spacing.d4,
                ),
                child: ListItem(
                  onDoubleTap: () => entity.doubleTap(context),
                  enableAnimation: false,
                  leading: ImageView(
                    entity.entityIcon,
                    color: entity.getEntityColor(context),
                    size: Spacing.d20,
                  ),
                  titlePadding: EdgeInsets.only(
                    left: Spacing.d8,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.d8,
                    vertical: Spacing.d4,
                  ),
                  title: Text(
                    entity.name,
                    style: TextStyle(
                      color: entity.isHidden
                          ? context.appTheme.color.disabledIconColor
                          : context.appTheme.color.onBackground,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
