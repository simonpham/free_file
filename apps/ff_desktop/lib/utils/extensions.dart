import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/utils/platform_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/constants/constants.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

extension ScreenSizeBuildContextExtension on BuildContext {
  ScreenSize get screenSize => select((ThemeModel _) => _.screenSize);
}

extension SideBarSectionsExt on SideBarSection {
  Uri? get uri {
    switch (this) {
      case SideBarSection.yours:
      case SideBarSection.home:
        return PredefinedFolder.home.uri;
      case SideBarSection.pinned:
      case SideBarSection.cloud:
      case SideBarSection.drives:
      case SideBarSection.tags:
        return null;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case SideBarSection.home:
        return 'Home';
      case SideBarSection.pinned:
        return 'Pinned';
      case SideBarSection.cloud:
        return 'Cloud';
      case SideBarSection.yours:
        final home = PredefinedFolder.home.uri;
        if (home != null) {
          return home.toRealPath().getUsernameFromHomeFolder();
        }
        return 'Yours';
      case SideBarSection.drives:
        return 'Drives';
      case SideBarSection.tags:
        return 'Tags';
    }
  }

  SvgGenImage? getIcon(BuildContext context) {
    switch (this) {
      case SideBarSection.home:
        return Assets.icons.interface.outline.home02;
      case SideBarSection.pinned:
        return Assets.icons.interface.outline.pin;
      case SideBarSection.cloud:
        return Assets.icons.device.outline.computerCloud;
      case SideBarSection.yours:
        return Assets.icons.interface.outline.home02;
      case SideBarSection.drives:
        return Assets.icons.device.outline.storage;
      case SideBarSection.tags:
        return Assets.icons.ecommerce.outline.tag;
    }
  }

  SvgGenImage? getSelectedIcon(BuildContext context) {
    switch (this) {
      case SideBarSection.home:
        return Assets.icons.interface.solid.home02;
      case SideBarSection.pinned:
        return Assets.icons.interface.solid.pin;
      case SideBarSection.cloud:
        return Assets.icons.device.solid.computerCloud;
      case SideBarSection.yours:
        return Assets.icons.interface.solid.home02;
      case SideBarSection.drives:
        return Assets.icons.device.solid.storage;
      case SideBarSection.tags:
        return Assets.icons.ecommerce.solid.tag;
    }
  }
}

extension PredefinedFoldersExt on PredefinedFolder {
  SvgGenImage get icon {
    switch (this) {
      case PredefinedFolder.home:
        return Assets.icons.interface.outline.home01;
      case PredefinedFolder.desktop:
        return Assets.icons.interface.outline.computer;
      case PredefinedFolder.downloads:
        return Assets.icons.filesAndFolder.outline.folderDownload;
      case PredefinedFolder.documents:
        return Assets.icons.editor.outline.description;
      case PredefinedFolder.pictures:
        return Assets.icons.interface.outline.imageRectangle;
      case PredefinedFolder.videos:
        return Assets.icons.multimediaAndAudio.outline.clapperboard;
      case PredefinedFolder.movies:
        return Assets.icons.multimediaAndAudio.outline.film03;
      case PredefinedFolder.music:
        return Assets.icons.multimediaAndAudio.outline.music;
      case PredefinedFolder.trash:
        return Assets.icons.interface.outline.trash;
    }
  }

  SvgGenImage get selectedIcon {
    switch (this) {
      case PredefinedFolder.home:
        return Assets.icons.interface.solid.home01;
      case PredefinedFolder.desktop:
        return Assets.icons.interface.solid.computer;
      case PredefinedFolder.downloads:
        return Assets.icons.filesAndFolder.solid.folderDownload;
      case PredefinedFolder.documents:
        return Assets.icons.editor.solid.description;
      case PredefinedFolder.pictures:
        return Assets.icons.interface.solid.imageRectangle;
      case PredefinedFolder.videos:
        return Assets.icons.multimediaAndAudio.solid.clapperboard;
      case PredefinedFolder.movies:
        return Assets.icons.multimediaAndAudio.solid.film03;
      case PredefinedFolder.music:
        return Assets.icons.multimediaAndAudio.solid.music;
      case PredefinedFolder.trash:
        return Assets.icons.interface.solid.trash;
    }
  }

  Uri? get uri {
    final homePath = PlatformUtils.getHomePath();
    switch (this) {
      case PredefinedFolder.home:
        if (homePath == null) {
          return null;
        }
        return Uri.parse(homePath).ifExists;
      case PredefinedFolder.desktop:
        return Uri.parse('$homePath${kSlash}Desktop').ifExists;
      case PredefinedFolder.downloads:
        return Uri.parse('$homePath${kSlash}Downloads').ifExists;
      case PredefinedFolder.documents:
        return Uri.parse('$homePath${kSlash}Documents').ifExists;
      case PredefinedFolder.pictures:
        return Uri.parse('$homePath${kSlash}Pictures').ifExists;
      case PredefinedFolder.videos:
        return Uri.parse('$homePath${kSlash}Videos').ifExists;
      case PredefinedFolder.movies:
        return Uri.parse('$homePath${kSlash}Movies').ifExists;
      case PredefinedFolder.music:
        return Uri.parse('$homePath${kSlash}Music').ifExists;
      case PredefinedFolder.trash:
        if (kIsMacOs) {
          return Uri.parse('$homePath$kSlash.Trash').ifExists;
        }
        return null;
      default:
        return null;
    }
  }
}

extension ExplorerViewModeExt on ViewMode {
  bool get isZoomable => this == ViewMode.grid;
}
