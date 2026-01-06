import 'dart:async';
import 'dart:math';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

typedef PositionCallback = void Function(Offset position);

enum BorderType { top, bottom, left, right }

class SelectRectangleOverlay extends StatefulWidget {
  final ScrollController scrollController;

  final ValueChanged<Rect> onRectangleUpdated;
  final PositionCallback onDragUpdate;
  final PositionCallback onDragStart;
  final VoidCallback onDragEnd;
  final ValueChanged<Set<BorderType>> onReachedBorder;

  final Widget child;

  const SelectRectangleOverlay({
    super.key,
    required this.scrollController,
    required this.onRectangleUpdated,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onReachedBorder,
    required this.child,
  });

  @override
  State<SelectRectangleOverlay> createState() => _SelectRectangleOverlayState();
}

class _SelectRectangleOverlayState extends State<SelectRectangleOverlay>
    with AfterLayoutMixin {
  bool _isTapDown = false;
  bool _isDragging = false;

  Offset _x0y0 = Offset.zero;
  Offset _x1y1 = Offset.zero;
  double _startOffset = 0.0;
  double _endOffset = 0.0;

  void _onScroll() {
    final currentScrollPosition = widget.scrollController.offset;
    _endOffset = currentScrollPosition;
    refresh();
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
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          widget.onDragEnd();
          _resetDrag();
        }
      },
      onPointerDown: (event) {
        widget.onDragStart(event.localPosition);
        _x0y0 = event.localPosition;
        _startOffset = widget.scrollController.offset;
        _endOffset = widget.scrollController.offset;
        _isTapDown = true;
      },
      onPointerMove: (event) {
        if (!_isTapDown) {
          return;
        }
        _isDragging = true;

        widget.onDragUpdate(event.localPosition);
        _x1y1 = event.localPosition;
        refresh();

        // Calculate absolute content-space coordinates
        // For vertical scrolling: X stays the same, Y is adjusted by scroll offset
        // For horizontal scrolling: Y stays the same, X is adjusted by scroll offset
        final scrollController = widget.scrollController;
        final isHorizontalScroll =
            scrollController.position.axis == Axis.horizontal;

        double absoluteStartX, absoluteStartY, absoluteEndX, absoluteEndY;

        if (isHorizontalScroll) {
          // Horizontal scroll: adjust X by scroll offset
          absoluteStartX = _x0y0.dx + _startOffset;
          absoluteStartY = _x0y0.dy;
          absoluteEndX = _x1y1.dx + _endOffset;
          absoluteEndY = _x1y1.dy;
        } else {
          // Vertical scroll: adjust Y by scroll offset
          absoluteStartX = _x0y0.dx;
          absoluteStartY = _x0y0.dy + _startOffset;
          absoluteEndX = _x1y1.dx;
          absoluteEndY = _x1y1.dy + _endOffset;
        }

        final leftPosition = min(absoluteStartX, absoluteEndX);
        final topPosition = min(absoluteStartY, absoluteEndY);
        final rectWidth = (absoluteEndX - absoluteStartX).abs();
        final rectHeight = (absoluteEndY - absoluteStartY).abs();
        final rect =
            Rect.fromLTWH(leftPosition, topPosition, rectWidth, rectHeight);

        widget.onRectangleUpdated(rect);
        _handleDetectBorder(size, _x0y0, _x1y1, _startOffset, _endOffset);
      },
      onPointerUp: (event) {
        widget.onDragEnd();
        _isTapDown = false;
        _resetDrag();
      },
      onPointerCancel: (event) {
        widget.onDragEnd();
        _resetDrag();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: widget.child),
          if (_isDragging && _isTapDown)
            Builder(
              builder: (context) {
                // Visual rectangle uses simple screen coordinates
                final visualLeft = min(_x0y0.dx, _x1y1.dx);
                final visualTop = min(_x0y0.dy, _x1y1.dy);
                final visualWidth = (_x1y1.dx - _x0y0.dx).abs();
                final visualHeight = (_x1y1.dy - _x0y0.dy).abs();

                return Positioned(
                  left: visualLeft,
                  top: visualTop,
                  child: Container(
                    width: visualWidth,
                    height: visualHeight,
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

  void _resetDrag() {
    _isDragging = false;

    _x0y0 = Offset.zero;
    _x1y1 = Offset.zero;
    _startOffset = 0.0;
    _endOffset = 0.0;
    refresh();
  }
}
