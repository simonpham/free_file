import 'package:core/core.dart';
import 'package:flutter/material.dart';

class KeyHoldDetector extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isPressedAltOption,
    bool isPressedShift,
    bool isPressedControlCommand,
  ) builder;

  const KeyHoldDetector({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HoldKeyEvent>(
      initialData: const HoldKeyEvent(false),
      stream: injector<EventBus>().on<HoldKeyEvent>(),
      builder: (BuildContext context, AsyncSnapshot<HoldKeyEvent> snapshot) {
        bool isPressedAltOption = false;
        bool isPressedShift = false;
        bool isPressedControlCommand = false;
        if (snapshot.data is HoldAltOptionEvent) {
          isPressedAltOption = (snapshot.data as HoldAltOptionEvent).isPressed;
        } else if (snapshot.data is HoldShiftEvent) {
          isPressedShift = (snapshot.data as HoldShiftEvent).isPressed;
        } else if (snapshot.data is HoldControlCommandEvent) {
          isPressedControlCommand =
              (snapshot.data as HoldControlCommandEvent).isPressed;
        }
        return builder(
          context,
          isPressedAltOption,
          isPressedShift,
          isPressedControlCommand,
        );
      },
    );
  }
}
