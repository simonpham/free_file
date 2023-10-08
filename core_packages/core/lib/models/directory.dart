import 'package:core/core.dart';

class Directory extends Entity {
  const Directory({
    required super.name,
    required super.path,
    required super.createdAt,
    required super.updatedAt,
  }) : super(type: EntityType.directory);
}
