import 'dart:async';

import 'package:core/core.dart';

mixin DirectoryActions {
  bool hasSubDirectories(Directory directory);

  FutureOr<Directory> createDirectory(Uri path);

  FutureOr<void> deleteDirectory(Uri path);

  FutureOr<Directory> moveDirectory(Uri path, Uri newPath);

  FutureOr<Directory> copyDirectory(Uri path, Uri newPath);

  FutureOr<Directory> renameDirectory(Uri path, String newName) {
    final newPath = path.resolve(newName);
    return moveDirectory(path, newPath);
  }
}
