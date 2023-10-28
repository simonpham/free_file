import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';

class AddressBar extends StatelessWidget {
  const AddressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: context.appTheme.color.mainBackground.withTransparency,
        borderRadius: BorderRadius.circular(
          Spacing.d8,
        ),
      ),
      margin: EdgeInsets.all(
        Spacing.d4,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
      ),
      child: Selector<ExploreViewModel, TextEditingController>(
        selector: (BuildContext context, ExploreViewModel model) {
          return model.addressBarController;
        },
        builder: (BuildContext context, TextEditingController controller, _) {
          return TextField(
            controller: controller,
            onSubmitted: (value) {
              final uri = Uri.parse(value);
              context.read<ExploreViewModel>().goTo(uri);
            },
            style: context.theme.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
          );
        },
      ),
    );
  }
}
