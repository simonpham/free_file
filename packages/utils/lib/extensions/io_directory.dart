part of 'extensions.dart';

typedef ProgressCallback = void Function(int current, int total);

extension DirectoryExtension on io.Directory {
  Future<void> createIfNotExists() async {
    if (!await exists()) {
      await create(recursive: true);
    }
  }

  Future<void> deleteIfExists() async {
    if (await exists()) {
      await delete(recursive: true);
    }
  }

  Future<void> copyContent(
    io.Directory target, {
    ProgressCallback? onProgress,
    VoidCallback? onDone,
  }) async {
    final files = await list(
      recursive: true,
      followLinks: false,
    ).toList();

    final total = files.length;
    for (final file in files) {
      onProgress?.call(files.indexOf(file), total);
      final newPath = target.path + file.path.replaceFirst(path, '');
      if (file is io.Directory) {
        await io.Directory(newPath).create(recursive: true);
      } else if (file is io.File) {
        if (kIsMacOs && file.path.endsWith(kMacOsDsStore)) {
          continue;
        }
        final parent = io.Directory(newPath).parent;
        await parent.createIfNotExists();
        await file.copy(newPath);
      }
    }

    onDone?.call();
  }
}
