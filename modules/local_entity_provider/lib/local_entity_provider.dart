library local_entity_provider;

import 'dart:async';
import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:utils/utils.dart';
import 'package:win32/win32.dart';

class LocalEntityProvider extends EntityProvider {
  static HiddenStatus getHiddenStatus(Uri uri, io.FileStat stat) {
    if (kIsWindows) {
      final lpFileName = TEXT(uri.toRealPath());
      final attributes = GetFileAttributes(lpFileName);
      if ((attributes & FILE_ATTRIBUTE_SYSTEM) == FILE_ATTRIBUTE_SYSTEM) {
        return HiddenStatus.hiddenSystem;
      }
      if ((attributes & FILE_ATTRIBUTE_HIDDEN) == FILE_ATTRIBUTE_HIDDEN) {
        return HiddenStatus.hidden;
      }

      return HiddenStatus.normal;
    }
    return uri.lastNonEmptySegment.startsWith('.')
        ? HiddenStatus.hidden
        : HiddenStatus.normal;
  }

  @override
  bool hasSubDirectories(Directory directory) {
    final path = directory.path;
    final dir = io.Directory(path.toRealPath());
    final isExisted = dir.existsSync();
    if (!isExisted) {
      return false;
    }

    final stats = dir.statSync();
    if (stats.type != io.FileSystemEntityType.directory) {
      return false;
    }

    try {
      final items = dir.listSync(recursive: false);
      for (final item in items) {
        if (item is io.Directory) {
          return true;
        }
      }
    } catch (err, trace) {
      printError(err, trace);
    }

    return false;
  }

  @override
  Future<List<Entity>> list(Uri path) async {
    final result = <Entity>[];
    final dir = io.Directory(path.toRealPath());
    final isExisted = await dir.exists();
    if (!isExisted) {
      throw const FreeError(Error.directoryNotFound);
    }

    final hiddenFolders = <Directory>[];
    final folders = <Directory>[];

    final items = dir.list(recursive: false);
    await for (final item in items) {
      final stat = await item.stat();

      if (item is io.File) {
        final mimeType = lookupMimeType(item.path);
        final file = File(
          fileType: kMimeTypes[mimeType],
          size: stat.size,
          extension: item.path.split('.').last,
          name: item.path.split(kSlash).last,
          path: item.uri.normalizePath(),
          hiddenStatus: getHiddenStatus(item.uri, stat),
          createdAt: stat.changed.toIso8601String(),
          updatedAt: stat.modified.toIso8601String(),
        );
        result.add(file);
        continue;
      }

      if (item is io.Directory) {
        final dir = Directory(
          name: item.path.split(kSlash).last,
          path: item.uri.normalizePath().trim(),
          hiddenStatus: getHiddenStatus(item.uri, stat),
          createdAt: stat.changed.toIso8601String(),
          updatedAt: stat.modified.toIso8601String(),
        );
        folders.add(dir);
        continue;
      }
    }

    result.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    folders.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    hiddenFolders.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    result.insertAll(0, folders);
    result.insertAll(0, hiddenFolders);

    return result;
  }

  @override
  Future<Entity?> get(Uri path) async {
    final file = io.File(path.toRealPath());
    final directory = io.Directory(path.toRealPath());
    final isFileExisted = await file.exists();
    final isDirectoryExisted = await directory.exists();
    if (!isFileExisted && !isDirectoryExisted) {
      throw const FreeError(Error.fileNotFound);
    }

    final io.FileStat stat = await file.stat();
    if (stat.type == io.FileSystemEntityType.file) {
      final mimeType = lookupMimeType(file.path);
      final entity = File(
        size: stat.size,
        fileType: kMimeTypes[mimeType],
        extension: file.path.split('.').last,
        name: file.path.split(kSlash).last,
        path: file.uri.normalizePath(),
        hiddenStatus: getHiddenStatus(file.uri, stat),
        createdAt: stat.changed.toIso8601String(),
        updatedAt: stat.modified.toIso8601String(),
      );

      return entity;
    }

    if (stat.type == io.FileSystemEntityType.directory) {
      final entity = Directory(
        name: file.path.split(kSlash).last,
        path: file.uri.normalizePath().trim(),
        hiddenStatus: getHiddenStatus(file.uri, stat),
        createdAt: stat.changed.toIso8601String(),
        updatedAt: stat.modified.toIso8601String(),
      );

      return entity;
    }

    return null;
  }

  @override
  Future<File> createFile(Uri path) async {
    final file = io.File(path.toRealPath());
    final isExisted = await file.exists();
    if (isExisted) {
      throw const FreeError(Error.fileAlreadyExists);
    }

    await file.create(recursive: true, exclusive: true);
    final mimeType = lookupMimeType(file.path);

    final stat = await file.stat();
    final entity = File(
      size: stat.size,
      fileType: kMimeTypes[mimeType],
      extension: file.path.split('.').last,
      name: file.path.split(kSlash).last,
      path: file.uri.normalizePath(),
      hiddenStatus: getHiddenStatus(file.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );

    return entity;
  }

  @override
  Future<Directory> createDirectory(Uri path) async {
    final dir = io.Directory(path.toRealPath());
    final isExisted = await dir.exists();
    if (isExisted) {
      throw const FreeError(Error.directoryAlreadyExists);
    }

    await dir.create(recursive: true);

    final stat = await dir.stat();
    return Directory(
      name: dir.path.split(kSlash).last,
      path: dir.uri.normalizePath(),
      hiddenStatus: getHiddenStatus(dir.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );
  }

  @override
  Future<void> deleteFile(Uri path) async {
    final file = io.File(path.toRealPath());
    final isExisted = await file.exists();
    if (!isExisted) {
      throw const FreeError(Error.fileNotFound);
    }

    await file.delete();
  }

  @override
  Future<File> moveFile(Uri path, Uri newPath) async {
    final file = io.File(path.toRealPath());
    final isExisted = await file.exists();

    if (!isExisted) {
      throw const FreeError(Error.fileNotFound);
    }

    final newFile = io.File(newPath.toRealPath());
    final isNewExisted = await newFile.exists();
    if (isNewExisted) {
      throw const FreeError(Error.fileAlreadyExists);
    }

    final moved = await file.rename(newPath.toRealPath());
    final stat = await moved.stat();
    final mimeType = lookupMimeType(moved.path);

    return File(
      size: stat.size,
      fileType: kMimeTypes[mimeType],
      extension: moved.path.split('.').last,
      name: moved.path.split(kSlash).last,
      path: moved.uri.normalizePath(),
      hiddenStatus: getHiddenStatus(moved.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );
  }

  @override
  Future<File> copyFile(Uri path, Uri newPath) async {
    final file = io.File(path.toRealPath());
    final isExisted = await file.exists();

    if (!isExisted) {
      throw const FreeError(Error.fileNotFound);
    }

    final newFile = io.File(newPath.toRealPath());
    final isNewExisted = await newFile.exists();
    if (isNewExisted) {
      throw const FreeError(Error.fileAlreadyExists);
    }

    await file.copy(newPath.toRealPath());
    final stat = await newFile.stat();
    final mimeType = lookupMimeType(newFile.path);

    return File(
      size: stat.size,
      fileType: kMimeTypes[mimeType],
      extension: newFile.path.split('.').last,
      name: newFile.path.split(kSlash).last,
      path: newFile.uri.normalizePath(),
      hiddenStatus: getHiddenStatus(newFile.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );
  }

  @override
  Future<Directory> copyDirectory(Uri path, Uri newPath) async {
    final dir = io.Directory(path.toRealPath());
    final isExisted = await dir.exists();

    if (!isExisted) {
      throw const FreeError(Error.directoryNotFound);
    }

    final newDir = io.Directory(newPath.toRealPath());
    final isNewExisted = await newDir.exists();
    if (isNewExisted) {
      throw const FreeError(Error.directoryAlreadyExists);
    }

    await dir.copyContent(newDir);
    final stat = await newDir.stat();

    return Directory(
      name: newDir.path.split(kSlash).last,
      path: newDir.uri.normalizePath(),
      hiddenStatus: getHiddenStatus(newDir.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );
  }

  @override
  Future<void> deleteDirectory(Uri path) async {
    final dir = io.Directory(path.toRealPath());
    final isExisted = await dir.exists();
    if (!isExisted) {
      throw const FreeError(Error.directoryNotFound);
    }

    await dir.delete(recursive: true);
  }

  @override
  Future<Directory> moveDirectory(Uri path, Uri newPath) async {
    final dir = io.Directory(path.toRealPath());
    final isExisted = await dir.exists();

    if (!isExisted) {
      throw const FreeError(Error.directoryNotFound);
    }

    final newDir = io.Directory(newPath.toRealPath());
    final isNewExisted = await newDir.exists();
    if (isNewExisted) {
      throw const FreeError(Error.directoryAlreadyExists);
    }

    await dir.rename(newPath.toRealPath());
    final stat = await newDir.stat();

    return Directory(
      name: newDir.path.split(kSlash).last,
      path: newDir.uri.normalizePath().trim(),
      hiddenStatus: getHiddenStatus(newDir.uri, stat),
      createdAt: stat.changed.toIso8601String(),
      updatedAt: stat.modified.toIso8601String(),
    );
  }
}
