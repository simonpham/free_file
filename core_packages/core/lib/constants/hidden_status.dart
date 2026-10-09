enum HiddenStatus {
  normal,
  hidden,
  hiddenSystem;

  bool get isHidden => this != HiddenStatus.normal;
}
