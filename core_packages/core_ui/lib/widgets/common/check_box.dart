import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class CheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CheckBox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isChecked = widget.value;
      if (mounted) {
        setState(() {});
      }
    }
  }

  final ValueNotifier<bool> isHoverNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () {
        _isChecked = !_isChecked;
        widget.onChanged.call(_isChecked);
        setState(() {});
      },
      onStateChanged: (state) {
        isHoverNotifier.value = state == TappableState.hover;
      },
      enableHover: true,
      hoverOverlayBorderRadius: Spacing.d4 + Spacing.d2,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHoverNotifier,
        builder: (context, isHover, child) {
          return AnimatedContainer(
            duration: FludaDuration.ms2,
            height: Spacing.d24,
            width: Spacing.d24,
            decoration: BoxDecoration(
              color: _isChecked
                  ? context.theme.primaryColor
                  : (isHover
                      ? context.checkBoxBorderColor
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(Spacing.d4 + Spacing.d2),
              border: Border.all(
                color: _isChecked
                    ? context.theme.primaryColor
                    : context.checkBoxBorderColor,
                width: Spacing.d2,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: child,
          );
        },
        child: _isChecked
            ? Icon(
                Icons.check,
                size: Spacing.d20,
                color: context.onPrimaryColor,
              )
            : null,
      ),
    );
  }
}
