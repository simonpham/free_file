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
  final List<(Uri, SvgGenImage, SvgGenImage)> _items = [];

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
            _items.add((uri, folder.icon, folder.selectedIcon));
          }
        }
        break;
      case SideBarSections.drives:
        _items.addAll(
          io.Directory('/Volumes/').listSync().map((e) => e.uri).map(
                (e) => (
                  e,
                  Assets.icons.device.outline.storage,
                  Assets.icons.device.outline.storage
                ),
              ),
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
    final uri = widget.section.uri;
    return Consumer<ExploreViewModel>(builder: (context, model, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Spacing.d24),
          SideBarItem(
            uri: uri,
            title: widget.section.getLabel(context),
            selected: model.currentUri == uri,
            onTap: uri != null
                ? () {
                    widget.onGoTo(uri);
                  }
                : null,
            icon: widget.section.getIcon(context),
            selectedIcon: widget.section.getSelectedIcon(context),
            textStyle: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.d4),
          for (final (uri, icon, selectedIcon) in _items) ...[
            SizedBox(height: Spacing.d4),
            SideBarItem(
              uri: uri,
              icon: icon,
              selectedIcon: selectedIcon,
              selected: model.currentUri == uri,
              onTap: () {
                widget.onGoTo(uri);
              },
            ),
          ],
        ],
      );
    });
  }
}

class SideBarItem extends StatelessWidget {
  final String? title;
  final Uri? uri;
  final VoidCallback? onTap;

  final bool selected;

  final SvgGenImage? icon;
  final SvgGenImage? selectedIcon;
  final TextStyle? textStyle;

  const SideBarItem({
    super.key,
    this.title,
    this.uri,
    this.onTap,
    this.icon,
    this.selectedIcon,
    this.textStyle,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d16,
        vertical: Spacing.d4,
      ),
      child: Tappable(
        onTap: onTap,
        child: Row(
          children: [
            ImageView(
              selected ? selectedIcon : icon,
              size: Spacing.d20,
              color: context.theme.iconTheme.color,
            ),
            SizedBox(
              width: Spacing.d8,
            ),
            Flexible(
              child: Text(
                title ?? uri?.lastNonEmptySegment ?? '',
                style: textStyle ?? context.theme.textTheme.bodyLarge,
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
