import 'package:flutter/material.dart';
import 'package:shortcut/shortcut.dart';

export 'compress.dart';
export 'copy.dart';
export 'delete.dart';
export 'delete_permanently.dart';
export 'move.dart';
export 'open.dart';
export 'open_in_new_tab.dart';
export 'open_in_new_window.dart';
export 'paste.dart';
export 'properties.dart';
export 'quick_look.dart';
export 'rename.dart';

class EntityShortcuts {
  static Map<LogicalKeySet?, Intent> get entityContextShortcuts =>
      <LogicalKeySet?, Intent>{
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

  static Map<Type, Action<Intent>> getEntityContextActions(
    BuildContext context,
  ) {
    return <Type, Action<Intent>>{
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
    };
  }
}
