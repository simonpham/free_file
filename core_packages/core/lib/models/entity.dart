enum EntityType {
  file,
  directory,
}

class Entity {
  final EntityType type;

  final String name;
  final Uri path;

  final bool isHidden;

  final String createdAt;
  final String updatedAt;

  const Entity({
    required this.type,
    required this.name,
    required this.path,
    required this.isHidden,
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
          isHidden == other.isHidden &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode ^
      path.hashCode ^
      isHidden.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
