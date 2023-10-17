import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
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
      child: Selector<ExploreViewModel, (List<Entity>, ViewMode)>(
        selector: (BuildContext context, ExploreViewModel model) {
          return (model.entities, model.viewMode);
        },
        builder: (context, data, _) {
          return EntityView(
            entities: data.$1,
            mode: data.$2,
          );
        },
      ),
    );
  }
}
