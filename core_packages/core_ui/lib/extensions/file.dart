import 'package:core/constants/mime_types.dart';
import 'package:core/models/models.dart';
import 'package:core_ui/constants/constants.dart';

extension FileExtension on File {
  SvgGenImage get icon {
    final type = kMimeTypes[fileType.mimeType];
    switch (type) {
      case FileType.pdf:
        return Assets.icons.filesAndFolder.solid.filePdf;
      case FileType.doc:
      case FileType.docx:
        return Assets.icons.filesAndFolder.solid.fileDoc;
      case FileType.jpeg:
        return Assets.icons.filesAndFolder.solid.fileJpg;
      case FileType.png:
        return Assets.icons.filesAndFolder.solid.filePng;
      default:
    }

    switch (fileType.contentType) {
      case ContentType.audio:
        return Assets.icons.filesAndFolder.solid.fileMusic;
      case ContentType.image:
        return Assets.icons.multimediaAndAudio.solid.image;
      case ContentType.video:
        return Assets.icons.filesAndFolder.solid.fileVideo;
      case ContentType.text:
        return Assets.icons.editor.solid.documentText;
      case ContentType.application:
        return Assets.icons.filesAndFolder.solid.archive;
      default:
        return Assets.icons.filesAndFolder.solid.file04;
    }
  }
}
