import 'dart:io' as io;

import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';

extension on ScreenSize {
  double get sideBarWidth {
    switch (this) {
      case ScreenSize.extraLarge:
        return Spacing.d64 * 5;
      case ScreenSize.larger:
        return Spacing.d64 * 4;
      default:
        return Spacing.d64 * 3;
    }
  }
}

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TitlebarSafeArea(
      child: AnimatedContainer(
        duration: FludaDuration.ms3,
        width: context.screenSize.sideBarWidth,
        curve: Curves.easeOut,
        child: Column(
          children: [
            for (final section in SideBarSections.values)
              SideBarSection(
                section: section,
                onGoTo: (uri) {
                  context.read<ExploreViewModel>().goTo(uri);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SideBarSection extends StatefulWidget {
  final SideBarSections section;
  final ValueChanged<Uri> onGoTo;

  const SideBarSection({
    super.key,
    required this.section,
    required this.onGoTo,
  });

  @override
  State<SideBarSection> createState() => _SideBarSectionState();
}

class _SideBarSectionState extends State<SideBarSection> {
  final List<Uri> _items = [];

  @override
  void initState() {
    super.initState();
    switch (widget.section) {
      case SideBarSections.home:
        break;
      case SideBarSections.pinned:
        break;
      case SideBarSections.cloud:
        break;
      case SideBarSections.yours:
        for (final folder in PredefinedFolders.values) {
          if (folder == PredefinedFolders.home) {
            continue;
          }
          final uri = folder.uri;
          if (uri != null) {
            _items.add(uri);
          }
        }
        break;
      case SideBarSections.drives:
        _items.addAll(
          io.Directory('/Volumes/').listSync().map((e) => e.uri),
        );
        break;
      case SideBarSections.tags:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Spacing.d24,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.d24,
          ),
          child: Tappable(
            onTap: widget.section == SideBarSections.yours
                ? () {
                    final home = PredefinedFolders.home.uri;
                    if (home == null) {
                      return;
                    }
                    context.read<ExploreViewModel>().goTo(home);
                  }
                : null,
            child: Text(
              widget.section.getLabel(context),
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: Spacing.d8,
        ),
        for (final item in _items)
          SideBarItem(
            uri: item,
            onTap: () {
              widget.onGoTo(item);
            },
          ),
      ],
    );
  }
}

class SideBarItem extends StatelessWidget {
  final Uri uri;
  final VoidCallback onTap;

  const SideBarItem({
    super.key,
    required this.uri,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d24,
      ),
      child: Tappable(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              Icons.folder,
              size: Spacing.d24,
            ),
            SizedBox(
              width: Spacing.d16,
            ),
            Flexible(
              child: Text(
                uri.lastNonEmptySegment ?? '',
                style: context.theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
