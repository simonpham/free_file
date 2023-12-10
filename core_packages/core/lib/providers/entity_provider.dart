import 'dart:async';
import 'package:core/core.dart';

abstract class EntityProvider with FileActions, DirectoryActions {
  FutureOr<List<Entity>> list(Uri path);

  FutureOr<Entity?> get(Uri path);
}
