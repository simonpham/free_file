part of 'extensions.dart';

extension StringExtension on String {
  String getUsernameFromHomeFolder() {
    final parts = split(kSlash);
    if (parts.length > 2) {
      return parts[2];
    }
    return '';
  }

  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
}
