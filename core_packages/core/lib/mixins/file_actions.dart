import 'dart:async';

import 'package:core/core.dart';

mixin FileActions {
  FutureOr<File> createFile(Uri path);

  FutureOr<void> deleteFile(Uri path);

  FutureOr<File> moveFile(Uri path, Uri newPath);

  FutureOr<File> copyFile(Uri path, Uri newPath);

  FutureOr<File> renameFile(Uri path, String newName) {
    final newPath = path.resolve(newName);
    return moveFile(path, newPath);
  }
}
