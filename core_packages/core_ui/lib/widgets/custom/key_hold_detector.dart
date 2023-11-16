import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class KeyHoldDetector extends StatefulWidget {
  final Function(
    bool isPressedAltOption,
    bool isPressedShift,
    bool isPressedControlCommand,
  ) onHoldChanged;

  final Widget child;

  const KeyHoldDetector({
    super.key,
    required this.onHoldChanged,
    required this.child,
  });

  @override
  State<KeyHoldDetector> createState() => _KeyHoldDetectorState();
}

class _KeyHoldDetectorState extends State<KeyHoldDetector> {
  bool _isPressedAltOption = false;
  bool _isPressedShift = false;
  bool _isPressedControlCommand = false;

  StreamSubscription? _holdKeySubscription;

  @override
  void initState() {
    super.initState();
    _holdKeySubscription =
        injector<EventBus>().on<HoldKeyEvent>().listen(_onHoldKeyEvent);
  }

  @override
  void dispose() {
    _holdKeySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onHoldKeyEvent(HoldKeyEvent event) {
    if (event is HoldAltOptionEvent) {
      _isPressedAltOption = event.isPressed;
    } else if (event is HoldShiftEvent) {
      _isPressedShift = event.isPressed;
    } else if (event is HoldControlCommandEvent) {
      _isPressedControlCommand = event.isPressed;
    }
    widget.onHoldChanged(
      _isPressedAltOption,
      _isPressedShift,
      _isPressedControlCommand,
    );
  }
}

class KeyHoldDetectorBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isPressedAltOption,
    bool isPressedShift,
    bool isPressedControlCommand,
  ) builder;

  const KeyHoldDetectorBuilder({
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
