part of 'extensions.dart';

extension UriExtension on Uri {
  Uri trim() {
    final path = toFilePath().removeSuffix(kSlash);
    return Uri.parse(path);
  }

  String get lastNonEmptySegment {
    final path = toFilePath().removeSuffix(kSlash);
    final parts = path.split(kSlash);
    return parts.lastOrNull ?? '';
  }
}
