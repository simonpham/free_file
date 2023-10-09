import 'package:core/constants/constants.dart';

import 'package:core/models/models.dart';

class File extends Entity {
  final int size;
  final String extension;
  final FileType fileType;

  const File({
    required super.name,
    required super.path,
    FileType? fileType,
    required this.size,
    required this.extension,
    required super.createdAt,
    required super.updatedAt,
  })  : fileType = fileType ?? FileType.unknown,
        super(type: EntityType.file);
}
