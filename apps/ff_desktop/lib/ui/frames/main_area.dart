import 'dart:async';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:ff_desktop/constants/constants.dart';
import 'package:ff_desktop/utils/entity_utils.dart';
import 'package:flutter/material.dart';

import 'package:ff_desktop/features/features.dart';
import 'package:theme/theme.dart';

class MainArea extends StatefulWidget {
  const MainArea({
    super.key,
  });

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  final ScrollController scrollController = ScrollController();

  StreamSubscription<ShortcutEvent>? _shortcutSubscription;
  StreamSubscription<HoldKeyEvent>? _holdKeySubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToShortcuts();
  }

  @override
  void dispose() {
    _cancelSubscription();
    super.dispose();
  }

  void _subscribeToShortcuts() {
    _cancelSubscription();
    _shortcutSubscription = injector<EventBus>().on<ShortcutEvent>().listen(
          _onShortcutEvent,
        );
    _holdKeySubscription = injector<EventBus>().on<HoldKeyEvent>().listen(
          _onHoldKeyEvent,
        );
  }

  void _cancelSubscription() {
    _shortcutSubscription?.cancel();
    _holdKeySubscription?.cancel();
    _shortcutSubscription = null;
    _holdKeySubscription = null;
  }

  void _onShortcutEvent(ShortcutEvent event) {
    debugPrint('ShortcutEvent: ${event.runtimeType}');
  }

  void _onHoldKeyEvent(HoldKeyEvent event) {
    debugPrint('HoldKeyEvent: ${event.runtimeType}: ${event.isPressed}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.appTheme.color.mainBackground.withTransparency,
      child: Selector<ExploreViewModel, (ViewMode, List<Entity>, Set<Entity>)>(
        selector: (BuildContext context, ExploreViewModel model) {
          return (model.viewMode, model.entities, model.selectedEntities);
        },
        builder: (context, data, _) {
          return EntityView(
            scrollController: scrollController,
            mode: data.$1,
            entities: data.$2,
            selectedEntities: data.$3,
            onSelectionChanged: (selectedEntities) {
              context.read<ExploreViewModel>().selectBatch(selectedEntities);
            },
            onEntityTap: (entity) {
              entity.tap(context);
            },
            onEntityDoubleTap: (entity) {
              entity.doubleTap(context);
            },
          );
        },
      ),
    );
  }
}
