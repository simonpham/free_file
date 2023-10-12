import 'dart:io' as io;

import 'package:flutter/material.dart';

enum SideBarSections {
  home,
  pinned,
  cloud,
  yours,
  drives,
  tags;

  final Uri? uri = null;

  String getLabel(BuildContext context) {
    switch (this) {
      case SideBarSections.home:
        return 'Home';
      case SideBarSections.pinned:
        return 'Pinned';
      case SideBarSections.cloud:
        return 'Cloud';
      case SideBarSections.yours:
        return 'Yours';
      case SideBarSections.drives:
        return 'Drives';
      case SideBarSections.tags:
        return 'Tags';
    }
  }
}

extension on Uri {
  Uri? get ifExists {
    final dir = io.Directory(toFilePath());
    if (dir.existsSync()) {
      return this;
    }
    return null;
  }
}

enum PredefinedFolders {
  home(icon: '', selectedIcon: ''),
  desktop(icon: '', selectedIcon: ''),
  downloads(icon: '', selectedIcon: ''),
  documents(icon: '', selectedIcon: ''),
  pictures(icon: '', selectedIcon: ''),
  videos(icon: '', selectedIcon: ''),
  movies(icon: '', selectedIcon: ''),
  music(icon: '', selectedIcon: '');

  final String icon;
  final String selectedIcon;

  const PredefinedFolders({
    required this.icon,
    required this.selectedIcon,
  });

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
