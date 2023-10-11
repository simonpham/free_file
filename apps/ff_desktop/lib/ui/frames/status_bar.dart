import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';

import 'package:ff_desktop/features/explore/explore.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: Row(
        children: [
          Expanded(
            child: Consumer<ExploreViewModel>(
              builder: (context, model, _) {
                return Text(model.currentUri.lastNonEmptySegment);
              },
            ),
          ),
          Selector<ExploreViewModel, int>(
            selector: (BuildContext context, ExploreViewModel model) {
              return model.entities.length;
            },
            builder: (context, length, _) {
              return Text('$length items');
            },
          ),
        ],
      ),
    );
  }
}
