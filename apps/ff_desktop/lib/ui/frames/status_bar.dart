import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        color: context.theme.colorScheme.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            Spacing.d8,
          ),
          bottomRight: Radius.circular(
            Spacing.d8,
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
                return Text(
                  '$length items',
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onBackground,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
