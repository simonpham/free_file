enum Error {
  fileNotFound,
  fileAlreadyExists,
  directoryNotFound,
  notADirectory,
  directoryAlreadyExists,
  noApplicationKnowsHowToOpenUrl,
  openFailed,
  unsupportedFile,
  notSupported;

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
      case Error.openFailed:
        return 'Open failed';
      case Error.noApplicationKnowsHowToOpenUrl:
        return 'No application knows how to open URL';
      case Error.unsupportedFile:
        return 'Unsupported file';
      case Error.notSupported:
        return 'Not supported';
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
