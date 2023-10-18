import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

typedef PositionCallback = void Function(Offset position);

enum BorderType {
  top,
  bottom,
  left,
  right,
}

class SelectRectangleOverlay extends StatelessWidget {
  final PositionCallback onDragUpdate;
  final PositionCallback onDragStart;
  final VoidCallback onDragEnd;
  final ValueChanged<Set<BorderType>> onReachedBorder;

  final Widget child;

  const SelectRectangleOverlay({
    Key? key,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onReachedBorder,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<(Offset, Offset)?> dragPositionNotifier =
        ValueNotifier<(Offset, Offset)?>(null);
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          onDragEnd();
        }
      },
      onPointerDown: (event) {
        onDragStart(event.localPosition);
        dragPositionNotifier.value = (event.localPosition, event.localPosition);
      },
      onPointerMove: (event) {
        onDragUpdate(event.localPosition);
        dragPositionNotifier.value = (
          dragPositionNotifier.value?.$1 ?? event.localPosition,
          event.localPosition,
        );
        final dragPosition = dragPositionNotifier.value;
        if (dragPosition == null) {
          return;
        }

        final size = MediaQuery.sizeOf(context);
        final (start, end) = dragPosition;
        final borderReached = <BorderType>{};

        if (start.dx < end.dx) {
          if (end.dx > size.width) {
            borderReached.add(BorderType.right);
          }
        } else {
          if (end.dx < 0) {
            borderReached.add(BorderType.left);
          }
        }

        if (start.dy < end.dy) {
          if (end.dy > size.height) {
            borderReached.add(BorderType.bottom);
          }
        } else {
          if (end.dy < 0) {
            borderReached.add(BorderType.top);
          }
        }

        if (borderReached.isEmpty) {
          return;
        }

        EasyThrottle.throttle(
          'border_reached',
          FludaDuration.ms2,
          () => onReachedBorder(borderReached),
        );
      },
      onPointerUp: (event) {
        onDragEnd();
        dragPositionNotifier.value = null;
      },
      onPointerCancel: (event) {
        onDragEnd();
        dragPositionNotifier.value = null;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: child),
          ValueListenableBuilder(
            valueListenable: dragPositionNotifier,
            builder: (BuildContext context, (Offset, Offset)? value, _) {
              if (value == null) {
                return const SizedBox();
              }
              final (start, end) = value;
              final width = (end.dx - start.dx).abs();
              final height = (end.dy - start.dy).abs();
              return Positioned(
                left: math.min(start.dx, end.dx),
                top: math.min(start.dy, end.dy),
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
