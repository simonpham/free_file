enum Error {
  fileNotFound,
  fileAlreadyExists,
  directoryNotFound,
  notADirectory,
  directoryAlreadyExists;

  String toReadableMessage() {
    switch (this) {
      case Error.fileNotFound:
        return 'File not found';
      case Error.fileAlreadyExists:
        return 'File already exists';
      case Error.directoryNotFound:
        return 'Directory not found';
      case Error.notADirectory:
        return 'Not a directory';
      case Error.directoryAlreadyExists:
        return 'Directory already exists';
    }
  }
}

class FreeError implements Exception {
  final Error error;

  const FreeError(this.error);

  @override
  String toString() {
    return error.toReadableMessage();
  }
}
