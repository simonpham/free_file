import 'package:core/constants/constants.dart';

enum EntityType {
  file,
  directory,
}

class Entity {
  final EntityType type;

  final String name;
  final Uri path;

  final HiddenStatus hiddenStatus;

  final String createdAt;
  final String updatedAt;

  const Entity({
    required this.type,
    required this.name,
    required this.path,
    required this.hiddenStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name == other.name &&
          path == other.path &&
          hiddenStatus == other.hiddenStatus &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode ^
      path.hashCode ^
      hiddenStatus.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
