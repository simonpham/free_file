class HoldKeyEvent {
  final bool isPressed;

  const HoldKeyEvent(this.isPressed);
}

class HoldAltOptionEvent extends HoldKeyEvent {
  const HoldAltOptionEvent(super.isPressed);
}

class HoldShiftEvent extends HoldKeyEvent {
  const HoldShiftEvent(super.isPressed);
}

class HoldControlCommandEvent extends HoldKeyEvent {
  const HoldControlCommandEvent(super.isPressed);
}
