import 'package:core/models/models.dart';
import 'package:core_ui/core_ui.dart';

extension EntityExtension on Entity {
  SvgGenImage get entityIcon {
    switch (type) {
      case EntityType.directory:
        final directory = this as Directory;
        return directory.icon;
      case EntityType.file:
        final file = this as File;
        return file.icon;
    }
  }
}
