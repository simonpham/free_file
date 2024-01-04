part of 'extensions.dart';

extension UriExtension on Uri {
  Uri append(String path) {
    final uri = toFilePath().removeSuffix(kSlash);
    return Uri.parse('$uri$kSlash$path');
  }

  Uri get parent {
    final path = toFilePath().removeSuffix(kSlash);
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
    final path = toFilePath().removeSuffix(kSlash);
    return Uri.parse(path.isEmpty ? kSlash : path);
  }

  String get lastNonEmptySegment {
    final path = toFilePath().removeSuffix(kSlash);
    final parts = path.split(kSlash);
    return parts.lastOrNull ?? '';
  }

  Uri? get ifExists {
    final dir = io.Directory(toFilePath());
    if (dir.existsSync()) {
      return this;
    }
    return null;
  }
}
