import 'dart:async';
import 'package:core/core.dart';

abstract class EntityProvider with FileActions, DirectoryActions {
  FutureOr<List<Entity>> list(
    Uri path, {
    DetailsSortColumn sort = DetailsSortColumn.name,
    SortDirection order = SortDirection.ascending,
  });

  FutureOr<Entity?> get(Uri path);
}
