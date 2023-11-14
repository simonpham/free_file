import 'package:flutter/material.dart';
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
