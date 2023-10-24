import 'dart:async';
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
  bool _isDragging = false;

  double _xMax = 0.0;
  double _yMax = 0.0;

  Offset _x0y0 = Offset.zero;
  Offset _x1y1 = Offset.zero;
  double _startOffset = 0.0;
  double _endOffset = 0.0;

  double get _width => _isLeft
      ? (_startOffset + _x0y0.dx) - (_x1y1.dx + _endOffset)
      : (_endOffset + _x1y1.dx) - (_x0y0.dx + _startOffset);

  double get _height => (_x1y1.dy - _x0y0.dy).abs();

  double get _left => _x1y1.dx;

  double get _right => _xMax - _x1y1.dx;

  double get _top => _x0y0.dy;

  double get _bottom => _yMax - _x0y0.dy;

  bool get _isLeft => _x1y1.dx + _endOffset < _x0y0.dx + _startOffset;

  bool get _isTop => _x1y1.dy > _x0y0.dy;

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
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _xMax = size.width;
    _yMax = size.height;
    return Builder(builder: (context) {
      return Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            _isDragging = false;
            widget.onDragEnd();
          }
        },
        onPointerDown: (event) {
          widget.onDragStart(event.localPosition);
          _isDragging = true;
          _x0y0 = event.localPosition;
          _startOffset = widget.scrollController.offset;
          refresh();
        },
        onPointerMove: (event) {
          widget.onDragUpdate(event.localPosition);
          _x1y1 = event.localPosition;
          refresh();

          _handleDetectBorder(size, _x0y0, _x1y1, _startOffset, _endOffset);
        },
        onPointerUp: (event) {
          widget.onDragEnd();
          _isDragging = false;
          refresh();
        },
        onPointerCancel: (event) {
          widget.onDragEnd();
          _isDragging = false;
          refresh();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: widget.child),
            if (_isDragging)
              Positioned(
                left: _isLeft ? _left : null,
                right: _isLeft ? null : _right,
                top: _isTop ? _top : null,
                bottom: _isTop ? null : _bottom,
                child: Container(
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
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
