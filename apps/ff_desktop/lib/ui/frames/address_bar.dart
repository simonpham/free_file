import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';

class AddressBar extends StatelessWidget {
  const AddressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: Selector<ExploreViewModel, Uri>(
        selector: (BuildContext context, ExploreViewModel model) {
          return model.currentUri;
        },
        builder: (BuildContext context, Uri uri, _) {
          return Text(
            uri.toFilePath(),
            style: context.theme.textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}
