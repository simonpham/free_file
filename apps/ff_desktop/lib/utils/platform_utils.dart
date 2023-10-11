import 'dart:io';

import 'package:core/core.dart';
import 'package:utils/utils.dart';

class PlatformUtils {
  static Future<Error?> open(
    Uri uri, {
    Uri? workingDirectory,
  }) async {
    final result = await Process.run(
      kOpenProcess,
      [uri.toFilePath()],
      workingDirectory: workingDirectory?.toFilePath(),
    );

    if (result.exitCode != 0 &&
        result.stderr.contains('kLSApplicationNotFoundErr')) {
      return Error.noApplicationKnowsHowToOpenUrl;
    }

    if (result.exitCode != 0) {
      return Error.openFailed;
    }

    return null;
  }
}
