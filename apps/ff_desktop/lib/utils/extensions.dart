import 'dart:io' as io;

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/constants/constants.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

extension ScreenSizeBuildContextExtension on BuildContext {
  ScreenSize get screenSize => select((ThemeModel _) => _.screenSize);
}

extension SideBarSectionsExt on SideBarSections {
  Uri? get uri {
    switch (this) {
      case SideBarSections.yours:
      case SideBarSections.home:
      case SideBarSections.pinned:
      case SideBarSections.cloud:
      case SideBarSections.drives:
      case SideBarSections.tags:
        return null;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case SideBarSections.home:
        return 'Home';
      case SideBarSections.pinned:
        return 'Pinned';
      case SideBarSections.cloud:
        return 'Cloud';
      case SideBarSections.yours:
        final home = PredefinedFolders.home.uri;
        if (home != null) {
          return home.toFilePath().getUsernameFromHomeFolder();
        }
        return 'Yours';
      case SideBarSections.drives:
        return 'Drives';
      case SideBarSections.tags:
        return 'Tags';
    }
  }

  SvgGenImage? getIcon(BuildContext context) {
    switch (this) {
      case SideBarSections.home:
        return Assets.icons.interface.outline.home02;
      case SideBarSections.pinned:
        return Assets.icons.interface.outline.pin;
      case SideBarSections.cloud:
        return Assets.icons.weather.outline.cloud;
      case SideBarSections.yours:
        return Assets.icons.interface.outline.home02;
      case SideBarSections.drives:
        return Assets.icons.device.outline.storage;
      case SideBarSections.tags:
        return Assets.icons.ecommerce.outline.tag;
    }
  }

  SvgGenImage? getSelectedIcon(BuildContext context) {
    switch (this) {
      case SideBarSections.home:
        return Assets.icons.interface.solid.home02;
      case SideBarSections.pinned:
        return Assets.icons.interface.solid.pin;
      case SideBarSections.cloud:
        return Assets.icons.weather.solid.cloud;
      case SideBarSections.yours:
        return Assets.icons.interface.solid.home02;
      case SideBarSections.drives:
        return Assets.icons.device.solid.storage;
      case SideBarSections.tags:
        return Assets.icons.ecommerce.solid.tag;
    }
  }
}

extension PredefinedFoldersExt on PredefinedFolders {
  SvgGenImage get icon {
    switch (this) {
      case PredefinedFolders.home:
        return Assets.icons.interface.outline.home01;
      case PredefinedFolders.desktop:
        return Assets.icons.interface.outline.computer;
      case PredefinedFolders.downloads:
        return Assets.icons.filesAndFolder.outline.folderDownload;
      case PredefinedFolders.documents:
        return Assets.icons.editor.outline.description;
      case PredefinedFolders.pictures:
        return Assets.icons.interface.outline.imageRectangle;
      case PredefinedFolders.videos:
        return Assets.icons.multimediaAndAudio.outline.clapperboard;
      case PredefinedFolders.movies:
        return Assets.icons.multimediaAndAudio.outline.film03;
      case PredefinedFolders.music:
        return Assets.icons.multimediaAndAudio.outline.music;
    }
  }

  SvgGenImage get selectedIcon {
    switch (this) {
      case PredefinedFolders.home:
        return Assets.icons.interface.solid.home01;
      case PredefinedFolders.desktop:
        return Assets.icons.interface.solid.computer;
      case PredefinedFolders.downloads:
        return Assets.icons.filesAndFolder.solid.folderDownload;
      case PredefinedFolders.documents:
        return Assets.icons.editor.solid.description;
      case PredefinedFolders.pictures:
        return Assets.icons.interface.solid.imageRectangle;
      case PredefinedFolders.videos:
        return Assets.icons.multimediaAndAudio.solid.clapperboard;
      case PredefinedFolders.movies:
        return Assets.icons.multimediaAndAudio.solid.film03;
      case PredefinedFolders.music:
        return Assets.icons.multimediaAndAudio.solid.music;
    }
  }

  Uri? get uri {
    final homePath = io.Platform.isWindows
        ? io.Platform.environment['USERPROFILE']
        : io.Platform.environment['HOME'];
    switch (this) {
      case PredefinedFolders.home:
        return Uri.parse('$homePath').ifExists;
      case PredefinedFolders.desktop:
        return Uri.parse('$homePath/Desktop').ifExists;
      case PredefinedFolders.downloads:
        return Uri.parse('$homePath/Downloads').ifExists;
      case PredefinedFolders.documents:
        return Uri.parse('$homePath/Documents').ifExists;
      case PredefinedFolders.pictures:
        return Uri.parse('$homePath/Pictures').ifExists;
      case PredefinedFolders.videos:
        return Uri.parse('$homePath/Videos').ifExists;
      case PredefinedFolders.movies:
        return Uri.parse('$homePath/Movies').ifExists;
      case PredefinedFolders.music:
        return Uri.parse('$homePath/Music').ifExists;
    }
  }
}

extension ExplorerViewModeExt on ViewMode {
  bool get isZoomable => this == ViewMode.grid;
}
