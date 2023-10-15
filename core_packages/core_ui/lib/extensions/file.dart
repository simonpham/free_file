import 'package:core/constants/mime_types.dart';
import 'package:core/models/models.dart';
import 'package:core_ui/constants/constants.dart';

extension FileExtension on File {
  SvgGenImage get icon {
    switch (fileType.contentType) {
      case ContentType.audio:
        return Assets.icons.multimediaAndAudio.outline.music01;
      case ContentType.image:
        return Assets.icons.multimediaAndAudio.outline.image01;
      case ContentType.video:
        return Assets.icons.multimediaAndAudio.outline.clapperboard;
      case ContentType.text:
        return Assets.icons.editor.outline.documentText;
      case ContentType.application:
        return Assets.icons.filesAndFolder.outline.archive;
      default:
        return Assets.icons.filesAndFolder.outline.file;
    }
  }

  SvgGenImage get selectedIcon {
    switch (fileType.contentType) {
      case ContentType.audio:
        return Assets.icons.multimediaAndAudio.solid.music01;
      case ContentType.image:
        return Assets.icons.multimediaAndAudio.solid.image01;
      case ContentType.video:
        return Assets.icons.multimediaAndAudio.solid.clapperboard;
      case ContentType.text:
        return Assets.icons.editor.solid.documentText;
      case ContentType.application:
        return Assets.icons.filesAndFolder.solid.archive;
      default:
        return Assets.icons.filesAndFolder.solid.file;
    }
  }
}
