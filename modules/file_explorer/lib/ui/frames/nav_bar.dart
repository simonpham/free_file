import 'package:core_ui/core_ui.dart';
import 'package:file_explorer/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreViewModel>(
      builder: (BuildContext context, ExploreViewModel model, _) {
        final buttons = [
          if (ThemeConfigs().config.showBackButton)
            Tappable(
              onTap: switch (model.canBack) {
                true => () => model.back(),
                false => null,
              },
              child: ImageView(
                Assets.icons.arrows.outline.arrowLeft,
                color: switch (model.canBack) {
                  true => context.appTheme.color.iconColor,
                  false => context.theme.disabledColor,
                },
                size: Spacing.d24,
              ),
            ),
          if (ThemeConfigs().config.showForwardButton)
            Tappable(
              onTap: switch (model.canForward) {
                true => () => model.forward(),
                false => null,
              },
              child: ImageView(
                Assets.icons.arrows.outline.arrowRight,
                color: switch (model.canForward) {
                  true => context.appTheme.color.iconColor,
                  false => context.theme.disabledColor,
                },
                size: Spacing.d24,
              ),
            ),
          if (ThemeConfigs().config.showUpButton)
            Tappable(
              onTap: switch (model.canUp) {
                true => () => model.up(),
                false => null,
              },
              child: ImageView(
                Assets.icons.arrows.outline.arrowUp,
                color: switch (model.canUp) {
                  true => context.appTheme.color.iconColor,
                  false => context.theme.disabledColor,
                },
                size: Spacing.d24,
              ),
            ),
          if (ThemeConfigs().config.showRefreshButton)
            Tappable(
              onTap: () => model.refresh(),
              child: ImageView(
                Assets.icons.arrows.outline.reload,
                color: context.appTheme.color.iconColor,
                size: Spacing.d24,
              ),
            ),
        ];
        return AnimatedSize(
          curve: Curves.easeOut,
          duration: FludaDuration.ms3,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Spacing.d12),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Center(child: buttons[index]);
            },
            separatorBuilder: (_, __) => SizedBox(width: Spacing.d8),
            itemCount: buttons.length,
          ),
        );
      },
    );
  }
}
