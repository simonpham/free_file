enum EntityType {
  file,
  directory,
}

class Entity {
  final EntityType type;

  final String name;
  final Uri path;

  final String createdAt;
  final String updatedAt;

  const Entity({
    required this.type,
    required this.name,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });
}
