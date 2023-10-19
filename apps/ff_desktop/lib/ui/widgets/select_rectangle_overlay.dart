import 'dart:async';
import 'dart:math' as math;
import 'package:core_ui/core_ui.dart';
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

class SelectRectangleOverlay extends StatefulWidget {
  final ScrollController scrollController;

  final PositionCallback onDragUpdate;
  final PositionCallback onDragStart;
  final VoidCallback onDragEnd;
  final ValueChanged<Set<BorderType>> onReachedBorder;

  final Widget child;

  const SelectRectangleOverlay({
    Key? key,
    required this.scrollController,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onReachedBorder,
    required this.child,
  }) : super(key: key);

  @override
  State<SelectRectangleOverlay> createState() => _SelectRectangleOverlayState();
}

class _SelectRectangleOverlayState extends State<SelectRectangleOverlay>
    with AfterLayoutMixin {
  /// <start, end, start offset, end offset>
  final ValueNotifier<(Offset, Offset, double, double)?> dragPositionNotifier =
      ValueNotifier(
    null,
  );

  void _onScroll() {
    final currentScrollPosition = widget.scrollController.offset;
    final dragPosition = dragPositionNotifier.value;
    if (dragPosition == null) {
      return;
    }
    final (start, end, startOffset, _) = dragPosition;
    dragPositionNotifier.value = (
      start,
      end,
      startOffset,
      currentScrollPosition,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          widget.onDragEnd();
        }
      },
      onPointerDown: (event) {
        widget.onDragStart(event.localPosition);
        dragPositionNotifier.value = (
          event.localPosition,
          event.localPosition,
          widget.scrollController.offset,
          widget.scrollController.offset,
        );
      },
      onPointerMove: (event) {
        final dragPosition = dragPositionNotifier.value;
        if (dragPosition == null) {
          return;
        }

        widget.onDragUpdate(event.localPosition);

        var (start, end, startOffset, endOffset) = dragPosition;
        final newEnd = event.localPosition;
        dragPositionNotifier.value = (start, newEnd, startOffset, endOffset);

        final size = MediaQuery.sizeOf(context);
        _handleDetectBorder(size, start, end, startOffset, endOffset);
      },
      onPointerUp: (event) {
        widget.onDragEnd();
        dragPositionNotifier.value = null;
      },
      onPointerCancel: (event) {
        widget.onDragEnd();
        dragPositionNotifier.value = null;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: widget.child),
          ValueListenableBuilder(
            valueListenable: dragPositionNotifier,
            builder: (
              BuildContext context,
              (Offset, Offset, double, double)? value,
              _,
            ) {
              if (value == null) {
                return const SizedBox();
              }
              final (start, end, startOffset, endOffset) = value;
              final offset = (endOffset - startOffset).abs();
              final width = (end.dx - start.dx).abs();
              final height = (end.dy - start.dy).abs();
              return Positioned(
                left: endOffset >= startOffset
                    ? math.min(start.dx - offset, end.dx)
                    : math.min(start.dx + offset, end.dx),
                top: math.min(start.dy, end.dy),
                child: Container(
                  width: width + offset,
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

  void _handleDetectBorder(
    Size size,
    Offset start,
    Offset end,
    double scrollOffset,
    double endOffset,
  ) {
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
      () => widget.onReachedBorder(borderReached),
    );
  }
}
