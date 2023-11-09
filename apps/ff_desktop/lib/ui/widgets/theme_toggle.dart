import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:storage/data/data.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ThemeToggle extends StatelessWidget {
  final bool isCollapsed;

  const ThemeToggle({
    Key? key,
    this.isCollapsed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeModel _) => _.themeMode);
    return Theme(
      data: context.theme.copyWith(
        brightness: Brightness.dark,
      ),
      child: GestureDetector(
        onDoubleTap: () {
          final model = context.read<ThemeModel>();
          model.enableTransparency = !model.enableTransparency;
        },
        child: isCollapsed
            ? Tappable(
                onTap: () {
                  Settings().themeMode = themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
                hoverOverlayBorderRadius: Spacing.d12,
                child: Padding(
                  padding: EdgeInsets.all(Spacing.d20),
                  child: Icon(
                    themeMode == ThemeMode.light
                        ? Icons.wb_sunny
                        : Icons.nightlight_round,
                    size: Spacing.d24,
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: CustomSlidingSegmentedControl<ThemeMode>(
                      groupValue: themeMode,
                      thumbColor:
                          context.theme.colorScheme.primary,
                      backgroundColor: context.theme.colorScheme.surface.withOpacity(0.3),
                      onValueChanged: (mode) {
                        if (mode != null) {
                          context.read<ThemeModel>().themeMode = mode;
                        }
                      },
                      children: {
                        ThemeMode.light: Padding(
                          padding: EdgeInsets.all(Spacing.d4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageView(
                                themeMode == ThemeMode.light
                                    ? Assets.icons.sunSolid
                                    : Assets.icons.sunOutline,
                                size: Spacing.d16,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Spacing.d8),
                                  child: Text(
                                    ThemeMode.light.name.capitalize(),
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color:
                                          context.theme.colorScheme.onPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ThemeMode.dark: Padding(
                          padding: EdgeInsets.all(Spacing.d4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageView(
                                themeMode == ThemeMode.dark
                                    ? Assets.icons.moonSolid
                                    : Assets.icons.moonOutline,
                                size: Spacing.d16,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Spacing.d8),
                                  child: Text(
                                    ThemeMode.dark.name.capitalize(),
                                    style: context.theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color:
                                          context.theme.colorScheme.onPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
