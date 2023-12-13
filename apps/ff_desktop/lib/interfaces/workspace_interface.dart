import 'dart:async';

import 'package:core/core.dart';

abstract interface class WorkspaceInterfaceCommands {
  FutureOr<void> copy({Set<Entity>? entities});

  FutureOr<void> paste({Uri? path});
}
