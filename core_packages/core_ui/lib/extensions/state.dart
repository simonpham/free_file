import 'package:flutter/widgets.dart';

extension StateExtension on State {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }

  void refresh() {
    safeSetState(() {});
  }
}
