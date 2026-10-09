import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DraggableWraper extends StatelessWidget {
  final Entity entity;

  final Widget child;

  const DraggableWraper({super.key, required this.entity, required this.child});

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (request) async {
        final item = DragItem(suggestedName: entity.name);
        item.add(Formats.fileUri(entity.path));
        return item;
      },
      allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(child: child),
    );
  }
}
