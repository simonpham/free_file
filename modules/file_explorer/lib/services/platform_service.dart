import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:utils/utils.dart';

class PlatformService {
  static Future<Error?> open(Uri uri, {Uri? workingDirectory}) async {
    final result = await io.Process.run(kOpenProcess, [
      uri.toRealPath(),
    ], workingDirectory: workingDirectory?.toRealPath());

    if (result.exitCode != 0 &&
        result.stderr.contains('kLSApplicationNotFoundErr')) {
      return Error.noApplicationKnowsHowToOpenUrl;
    }

    if (result.exitCode != 0) {
      return Error.openFailed;
    }

    return null;
  }

  static Future<Error?> openQuickLook(
    List<String> paths, {
    Uri? workingDirectory,
  }) async {
    if (!kIsMacOs) {
      return Error.notSupported;
    }

    final result = await io.Process.run(
      kMacOsQuickLookProcess,
      ['-p', ...paths],
      workingDirectory: workingDirectory?.toRealPath(),
      runInShell: true,
    );

    if (result.exitCode != 0) {
      return Error.openFailed;
    }

    return null;
  }

  static Future<(String?, Error?)> compress(
    List<String> paths, {
    String fileName = 'archive',
    required Uri workingDirectory,
  }) async {
    if (!kIsMacOs) {
      return (null, Error.notSupported);
    }

    String zipFilePath = '${workingDirectory.toRealPath()}$kSlash$fileName';
    int count = 1;
    while (await io.File('$zipFilePath.zip').exists()) {
      zipFilePath = '$zipFilePath-$count';
      count++;
    }

    /// Convert paths to relative paths.
    paths = paths.map((path) {
      return path.replaceFirst('${workingDirectory.toRealPath()}$kSlash', '');
    }).toList();

    zipFilePath = '$zipFilePath.zip';
    final result = await io.Process.run(kZipProcess, [
      '-r',
      zipFilePath,
      ...paths,
    ], workingDirectory: workingDirectory.toRealPath());

    if (result.exitCode != 0) {
      return (null, Error.compressFailed);
    }

    return (zipFilePath, null);
  }

  static String getVolumesPath() {
    if (kIsMacOs) {
      return '/Volumes/';
    }

    return '';
  }

  static String? getHomePath() {
    if (io.Platform.isWindows) {
      return io.Platform.environment['USERPROFILE'];
    }
    return io.Platform.environment['HOME'];
  }

  static String getIcloudDrivePath() {
    if (kIsMacOs) {
      return '/Users/${io.Platform.environment['USER']}/Library/Mobile Documents/com~apple~CloudDocs';
    }

    return '';
  }
}
