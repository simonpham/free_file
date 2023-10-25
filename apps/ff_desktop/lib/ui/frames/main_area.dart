import 'package:core/core.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: Selector<ExploreViewModel, (List<Entity>, ViewMode)>(
        selector: (BuildContext context, ExploreViewModel model) {
          return (model.entities, model.viewMode);
        },
        builder: (context, data, _) {
          return EntityView(
            scrollController: scrollController,
            entities: data.$1,
            mode: data.$2,
          );
        },
      ),
    );
  }
}
