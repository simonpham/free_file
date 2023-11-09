import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:ff_desktop/features/features.dart';
import 'package:ff_desktop/constants/constants.dart';

class AddressBar extends StatefulWidget {
  const AddressBar({
    super.key,
  });

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  TextEditingController get controller =>
      context.read<ExploreViewModel>().addressBarController;

  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  void _jumpToEnd() {
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d40,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: context.appTheme.color.mainBackground.withTransparency,
        borderRadius: BorderRadius.circular(
          Spacing.d8,
        ),
      ),
      margin: EdgeInsets.all(
        Spacing.d4,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
      ),
      child: _isEditing
          ? TextField(
              scrollController: scrollController,
              focusNode: focusNode,
              controller: controller,
              onSubmitted: _handleSubmitted,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
              onTapOutside: _disableEditMode,
              maxLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              textAlignVertical: TextAlignVertical.center,
              scrollPadding: EdgeInsets.zero,
            )
          : Tappable(
              mouseCursor: SystemMouseCursors.text,
              onTap: _enableEditMode,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Selector<ExploreViewModel, Uri>(
                      selector: (_, viewModel) => viewModel.currentUri,
                      builder: (context, uri, _) {
                        final segments = uri.trim().toFilePath().split(kSlash);
                        Future.delayed(Duration.zero, () {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: FludaDuration.ms2,
                            curve: Curves.easeOut,
                          );
                        });
                        return ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: segments.length,
                          separatorBuilder: (context, index) {
                            return const AddressDivider();
                          },
                          itemBuilder: (context, index) {
                            final segment = segments[index];
                            final isFirst = index == 0;
                            final isLast = index == segments.length - 1;
                            final shouldTruncate = !isLast &&
                                segment.length > kMaxDisplayAddressNameLength;
                            final displaySegment = isFirst
                                ? 'Root'
                                : shouldTruncate
                                    ? '${segment.substring(0, kMaxDisplayAddressNameLength)}...'
                                    : segment;
                            return Tooltip(
                              message: isLast ? controller.text : segment,
                              child: Tappable(
                                mouseCursor: isLast
                                    ? SystemMouseCursors.text
                                    : SystemMouseCursors.click,
                                onTap: () {
                                  if (isLast) {
                                    _enableEditMode();
                                    return;
                                  }
                                  _handleSegmentTapped(
                                    index,
                                    segments,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    displaySegment,
                                    style: context.theme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: isLast
                                          ? context.theme.colorScheme
                                              .onSurfaceVariant
                                          : context.theme.colorScheme
                                              .onSurfaceVariant
                                              .withOpacity(0.5),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _enableEditMode() {
    _isEditing = true;
    refresh();
    focusNode.requestFocus();
    Future.delayed(Duration.zero, _jumpToEnd);
  }

  void _disableEditMode(_) {
    _isEditing = false;
    refresh();
  }

  void _handleSubmitted(String value) {
    final uri = Uri.parse(value);
    context.read<ExploreViewModel>().goTo(uri);
  }

  void _handleSegmentTapped(int index, List<String> segments) {
    final uri = Uri.parse(
      segments.sublist(0, index + 1).join('/'),
    ).trim();
    context.read<ExploreViewModel>().goTo(uri);
  }
}

class AddressDivider extends StatelessWidget {
  const AddressDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spacing.d16,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: Spacing.d2 + Spacing.d1,
      ),
      child: ImageView(
        Assets.icons.arrows.solid.directionRight01,
        color: context.theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
        width: Spacing.d8 + Spacing.d2,
        height: Spacing.d20,
      ),
    );
  }
}
