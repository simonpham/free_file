import 'package:core/constants/mime_types.dart';
import 'package:core/models/models.dart';
import 'package:core_ui/constants/constants.dart';

extension FileExtension on File {
  SvgGenImage get icon {
    final type = kMimeTypes[fileType.mimeType];
    switch (type) {
      case FileType.pdf:
        return Assets.icons.filesAndFolder.outline.filePdf;
      case FileType.doc:
      case FileType.docx:
        return Assets.icons.filesAndFolder.outline.fileDoc;
      case FileType.jpeg:
        return Assets.icons.filesAndFolder.outline.fileJpg;
      case FileType.png:
        return Assets.icons.filesAndFolder.outline.filePng;
      default:
    }

    switch (fileType.contentType) {
      case ContentType.audio:
        return Assets.icons.filesAndFolder.outline.fileMusic;
      case ContentType.image:
        return Assets.icons.multimediaAndAudio.outline.image;
      case ContentType.video:
        return Assets.icons.filesAndFolder.outline.fileVideo;
      case ContentType.text:
        return Assets.icons.editor.outline.documentText;
      case ContentType.application:
        return Assets.icons.filesAndFolder.outline.archive;
      default:
        return Assets.icons.filesAndFolder.outline.file04;
    }
  }
}
