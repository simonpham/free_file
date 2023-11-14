import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortcut/shortcut.dart';

class GlobalShortcutWrapper extends StatefulWidget {
  final Widget child;

  const GlobalShortcutWrapper({
    super.key,
    required this.child,
  });

  @override
  State<GlobalShortcutWrapper> createState() => _GlobalShortcutWrapperState();
}

class _GlobalShortcutWrapperState extends State<GlobalShortcutWrapper> {
  final Map<LogicalKeySet, Intent> _shortcuts = {};

  @override
  void initState() {
    super.initState();
    final Map<LogicalKeySet?, Intent> shortcuts = <LogicalKeySet?, Intent>{
      CompressIntent.keySet: CompressIntent(),
      CopyIntent.keySet: CopyIntent(),
      DeleteIntent.keySet: DeleteIntent(),
      DeletePermanentlyIntent.keySet: DeletePermanentlyIntent(),
      MoveIntent.keySet: MoveIntent(),
      OpenIntent.keySet: OpenIntent(),
      OpenInNewTabIntent.keySet: OpenInNewTabIntent(),
      OpenInNewWindowIntent.keySet: OpenInNewWindowIntent(),
      RenameIntent.keySet: RenameIntent(),
      PasteIntent.keySet: PasteIntent(),
      PropertiesIntent.keySet: PropertiesIntent(),
      QuickLookIntent.keySet: QuickLookIntent(),
      RenameIntent.keySet: RenameIntent(),
    };

    for (final entry in shortcuts.entries) {
      final keySet = entry.key;
      if (keySet != null && keySet.keys.isNotEmpty) {
        _shortcuts[keySet] = entry.value;
      }
    }

    RawKeyboard.instance.addListener(_handleRawKeyEvent);
  }

  void _handleRawKeyEvent(RawKeyEvent event) {
    final isKeyDown = event is RawKeyDownEvent;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.shift:
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        injector<EventBus>().fire(
          HoldShiftEvent(isKeyDown),
        );
        break;
      case LogicalKeyboardKey.meta:
      case LogicalKeyboardKey.metaLeft:
      case LogicalKeyboardKey.metaRight:
      case LogicalKeyboardKey.control:
      case LogicalKeyboardKey.controlLeft:
      case LogicalKeyboardKey.controlRight:
        injector<EventBus>().fire(
          HoldControlCommandEvent(isKeyDown),
        );
        break;
      case LogicalKeyboardKey.alt:
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        injector<EventBus>().fire(
          HoldAltOptionEvent(isKeyDown),
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleRawKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          CompressIntent: CompressAction(context),
          CopyIntent: CopyAction(context),
          DeleteIntent: DeleteAction(context),
          DeletePermanentlyIntent: DeletePermanentlyAction(context),
          MoveIntent: MoveAction(context),
          OpenIntent: OpenAction(context),
          OpenInNewTabIntent: OpenInNewTabAction(context),
          OpenInNewWindowIntent: OpenInNewWindowAction(context),
          RenameIntent: RenameAction(context),
          PasteIntent: PasteAction(context),
          PropertiesIntent: PropertiesAction(context),
          QuickLookIntent: QuickLookAction(context),
        },
        child: widget.child,
      ),
    );
  }
}
