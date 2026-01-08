import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/services/services.dart';
import 'package:flutter/widgets.dart';
import 'package:l10n/l10n.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class WindowModeToggle extends StatefulWidget {
  const WindowModeToggle({super.key});

  @override
  State<WindowModeToggle> createState() => _WindowModeToggleState();
}

class _WindowModeToggleState extends State<WindowModeToggle> {
  WindowService get _windowService => injector<WindowService>();

  @override
  Widget build(BuildContext context) {
    if (!kIsMacOs) {
      return const SizedBox.shrink();
    }

    return Tappable(
      tooltip: context.localize.switchWindowMode,
      enableHover: true,
      enableHoverOverlay: true,
      hoverOverlayBorderRadius: Spacing.d4,
      hoverOverlayPadding: EdgeInsets.zero,
      onTap: () async {
        await _windowService.toggleWindowMode();
        if (!mounted) {
          return;
        }

        setState(() {});
      },
      child: Container(
        width: Spacing.d28,
        height: Spacing.d28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Spacing.d4),
        ),
        child: ImageView(
          _windowService.isWindowMode
              ? Assets.icons.arrows.outline.maximize01
              : Assets.icons.arrows.outline.minimize01,
          size: Spacing.d16,
          color: context.appTheme.color.iconColor,
        ),
      ),
    );
  }
}
