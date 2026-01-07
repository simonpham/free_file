import 'package:flutter/widgets.dart';
import 'package:l10n/generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension BuildContextL10n on BuildContext {
  S get localize {
    final s = S.of(this);
    if (s == null) {
      throw StateError('S not found in context');
    }
    return s;
  }
}
