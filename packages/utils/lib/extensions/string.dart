part of 'extensions.dart';

extension StringExtension on String {
  String truncateMiddlePath({
    int maxLength = 20,
  }) {
    final parts = split(kSlash);
    if (parts.length > 2) {
      final firstPart = parts[0];
      final lastPart = parts[parts.length - 1];
      final middlePart = parts.sublist(1, parts.length - 1).join(kSlash);
      if (firstPart.length + lastPart.length + middlePart.length > maxLength) {
        return '${firstPart.truncate(maxLength ~/ 2)}...${lastPart.truncate(maxLength ~/ 2)}';
      }
      return this;
    }
    return truncate(maxLength);
  }

  String truncate(int maxLength) {
    if (length > maxLength) {
      return '${substring(0, maxLength - 3)}...';
    }
    return this;
  }

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String getUsernameFromHomeFolder() {
    return basename(this);
  }

  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    }
    return this;
  }
}
