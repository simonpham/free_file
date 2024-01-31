part of 'extensions.dart';

extension UriExtension on Uri {
  Uri append(String path) {
    final uri = toRealPath().removeSuffix(kSlash);
    return Uri.parse('$uri$kSlash$path');
  }

  Uri get parent {
    final path = toRealPath().removeSuffix(kSlash);
    final parts = path.split(kSlash);
    if (parts.length > 1) {
      return Uri.parse(parts.sublist(0, parts.length - 1).join(kSlash));
    }
    return Uri.parse(kSlash);
  }

  Uri trim() {
    if (authority.isNotEmpty) {
      return this;
    }
    final path = toRealPath().removeSuffix(kSlash);
    return Uri.parse(path.isEmpty ? kSlash : path);
  }

  String get lastNonEmptySegment {
    final path = toRealPath().removeSuffix(kSlash);
    final parts = path.split(kSlash);
    return parts.lastOrNull ?? '';
  }

  Uri? get ifExists {
    final dir = io.Directory(toRealPath());
    if (dir.existsSync()) {
      return this;
    }
    return null;
  }

  String toRealPath() {
    if (kIsWindows) {
      const scheme = 'C:\\';
      String path ='${pathSegments.join(kSlash)}';
      if (path.toLowerCase().startsWith(scheme.toLowerCase())) {
        return path;
      }
      return '$scheme$path'.replaceAllMapped(
        kWindowsInvalidFileNameRegex,
        (match) => match.group(1) ?? '',
      );
    }
    return toFilePath();
  }
}
