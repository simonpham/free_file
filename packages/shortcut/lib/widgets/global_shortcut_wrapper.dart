import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortcut/shortcut.dart';

class GlobalShortcutWrapper extends StatefulWidget {
  final Widget child;

  const GlobalShortcutWrapper({super.key, required this.child});

  @override
  State<GlobalShortcutWrapper> createState() => _GlobalShortcutWrapperState();
}

class _GlobalShortcutWrapperState extends State<GlobalShortcutWrapper> {
  final Map<LogicalKeySet, Intent> _shortcuts = {};

  @override
  void initState() {
    super.initState();
    final Map<LogicalKeySet?, Intent> shortcuts = <LogicalKeySet?, Intent>{
      ...EntityShortcuts.entityContextShortcuts,
      ...WorkspaceShortcuts.workspaceShortcuts,
    };

    for (final entry in shortcuts.entries) {
      final keySet = entry.key;
      if (keySet != null && keySet.keys.isNotEmpty) {
        _shortcuts[keySet] = entry.value;
      }
    }

    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    final isKeyDown = event is KeyDownEvent;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.shift:
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        injector<EventBus>().fire(HoldShiftEvent(isKeyDown));
        return false;
      case LogicalKeyboardKey.meta:
      case LogicalKeyboardKey.metaLeft:
      case LogicalKeyboardKey.metaRight:
      case LogicalKeyboardKey.control:
      case LogicalKeyboardKey.controlLeft:
      case LogicalKeyboardKey.controlRight:
        injector<EventBus>().fire(HoldControlCommandEvent(isKeyDown));
        return false;
      case LogicalKeyboardKey.alt:
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        injector<EventBus>().fire(HoldAltOptionEvent(isKeyDown));
        return false;
      default:
        break;
    }
    return true;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          ...EntityShortcuts.getEntityContextActions(context),
          ...WorkspaceShortcuts.getWorkspaceActions(context),
        },
        child: widget.child,
      ),
    );
  }
}
