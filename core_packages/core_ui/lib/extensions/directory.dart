import 'package:core/models/models.dart';
import 'package:core_ui/constants/constants.dart';

extension DirectoryExtension on Directory {
  SvgGenImage get icon => Assets.icons.filesAndFolder.outline.folder03;

  SvgGenImage get selectedIcon => Assets.icons.filesAndFolder.solid.folder03;

  SvgGenImage get openIcon => Assets.icons.filesAndFolder.outline.folder;

  SvgGenImage get openSelectedIcon => Assets.icons.filesAndFolder.solid.folder;
}
