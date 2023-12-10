import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/features/explore/explore.dart';
import 'package:ff_desktop/models/models.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class HeheTabBar extends StatelessWidget {
  const HeheTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d28,
      margin: EdgeInsets.only(
        top: Spacing.d8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d12,
      ),
      alignment: Alignment.centerLeft,
      child: Consumer<TabViewModel>(
        builder: (BuildContext context, TabViewModel model, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ScrollablePositionedList.builder(
                  itemScrollController: model.tabScrollController,
                  itemPositionsListener: model.itemPositionsListener,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: model.exploreViewModels.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final item = model.exploreViewModels[index];
                    final isSelected = index == model.currentIndex;
                    final showCloseButton = model.exploreViewModels.length > 1;
                    return ChangeNotifierProvider.value(
                      value: item,
                      child: Consumer<ExploreViewModel>(
                        builder: (context, exploreModel, _) {
                          return Listener(
                            onPointerDown: (_) {
                              model.changeTab(index);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.appTheme.color.navBarBackground
                                        .withTransparency
                                    : context.appTheme.color.navBarBackground
                                        .applyTransparency(0.2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Spacing.d12,
                                  ),
                                  topRight: Radius.circular(
                                    Spacing.d12,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacing.d12,
                              ),
                              width: Spacing.d16 * 10,
                              child: Row(
                                children: [
                                  ImageView(
                                    isSelected
                                        ? Assets
                                            .icons.filesAndFolder.solid.folder03
                                        : Assets.icons.filesAndFolder.outline
                                            .folder03,
                                    size: Spacing.d16,
                                    color: context.appTheme.color.onBackground,
                                  ),
                                  SizedBox(width: Spacing.d8),
                                  Expanded(
                                    child: Text(
                                      exploreModel
                                          .currentUri.lastNonEmptySegment,
                                      style: context.theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: isSelected
                                            ? context
                                                .appTheme.color.onBackground
                                            : null,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (showCloseButton)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: Spacing.d4,
                                      ),
                                      child: Listener(
                                        behavior: HitTestBehavior.opaque,
                                        onPointerDown: (_) {
                                          model.removeExploreViewModelAt(
                                            index,
                                          );
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: ImageView(
                                            Assets.icons.interface.solid.remove,
                                            size: Spacing.d16,
                                            color: context
                                                .theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (_) {
                  model.addTab();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacing.d8,
                  ),
                  child: ImageView(
                    Assets.icons.interface.outline.plus,
                    size: Spacing.d16,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
