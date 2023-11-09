import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

import 'package:ff_desktop/features/explore/explore.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d32,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appTheme.color.statusBarBackground.withTransparency,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            Spacing.d12,
          ),
          bottomRight: Radius.circular(
            Spacing.d12,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
      ),
      child: AnimatedSize(
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
      ),
    );
  }
}
