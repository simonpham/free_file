import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ExploreViewModel>();
    final buttons = [
      if (ThemeConfigs().config.showBackButton)
        Tappable(
          onTap: model.canBack
              ? () {
                  model.back();
                }
              : null,
          child: ImageView(
            Assets.icons.arrows.outline.arrowLeft,
            color: model.canBack
                ? context.appTheme.color.iconColor
                : context.theme.disabledColor,
            size: Spacing.d24,
          ),
        ),
      if (ThemeConfigs().config.showForwardButton)
        Tappable(
          onTap: model.canForward
              ? () {
                  model.forward();
                }
              : null,
          child: ImageView(
            Assets.icons.arrows.outline.arrowRight,
            color: model.canForward
                ? context.appTheme.color.iconColor
                : context.theme.disabledColor,
            size: Spacing.d24,
          ),
        ),
      if (ThemeConfigs().config.showUpButton)
        Tappable(
          onTap: model.canUp
              ? () {
                  model.up();
                }
              : null,
          child: ImageView(
            Assets.icons.arrows.outline.arrowUp,
            color: model.canUp
                ? context.appTheme.color.iconColor
                : context.theme.disabledColor,
            size: Spacing.d24,
          ),
        ),
      if (ThemeConfigs().config.showRefreshButton)
        Tappable(
          onTap: () {
            model.refresh();
          },
          child: ImageView(
            Assets.icons.arrows.outline.reload,
            color: context.appTheme.color.iconColor,
            size: Spacing.d24,
          ),
        ),
    ];
    return Consumer<ExploreViewModel>(
      builder: (BuildContext context, ExploreViewModel model, _) {
        return AnimatedSize(
          curve: Curves.easeOut,
          duration: FludaDuration.ms3,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.d12,
            ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Center(child: buttons[index]);
            },
            separatorBuilder: (_, __) => SizedBox(
              width: Spacing.d8,
            ),
            itemCount: buttons.length,
          ),
        );
      },
    );
  }
}
