import 'package:core/constants/mime_types.dart';
import 'package:core/models/models.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension FileExtension on File {
  IconData get icon {
    switch (fileType.contentType) {
      case ContentType.audio:
        return FontAwesomeIcons.fileAudio;
      case ContentType.image:
        return FontAwesomeIcons.fileImage;
      case ContentType.video:
        return FontAwesomeIcons.fileVideo;
      case ContentType.text:
        return FontAwesomeIcons.fileLines;
      case ContentType.application:
        return FontAwesomeIcons.fileZipper;
      default:
        return FontAwesomeIcons.file;
    }
  }
}
