import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:utils/utils.dart';

/// A wrapper widget that enables dropping files and data from external
/// applications into the entity view.
///
/// Supports:
/// - File URIs (from Finder, etc.)
/// - Images (PNG, JPEG, GIF, WebP from browsers)
/// - Plain text
class DropRegionWrapper extends StatefulWidget {
  final Widget child;

  /// Called when files are dropped (from file manager).
  final ValueChanged<List<Uri>>? onFilesDropped;

  /// Called when binary data is dropped (e.g., image from browser).
  /// Parameters: data bytes, suggested filename, file extension.
  final void Function(Uint8List data, String? suggestedName, String extension)?
  onDataDropped;

  /// Called when text is dropped.
  final ValueChanged<String>? onTextDropped;

  const DropRegionWrapper({
    super.key,
    required this.child,
    this.onFilesDropped,
    this.onDataDropped,
    this.onTextDropped,
  });

  @override
  State<DropRegionWrapper> createState() => _DropRegionWrapperState();
}

class _DropRegionWrapperState extends State<DropRegionWrapper> {
  bool _isDragOver = false;

  /// Image formats we support, in order of preference.
  static final _imageFormats = [
    Formats.png,
    Formats.jpeg,
    Formats.gif,
    Formats.webp,
  ];

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: [Formats.fileUri, ..._imageFormats, Formats.plainText],
      hitTestBehavior: HitTestBehavior.opaque,
      onDropOver: _handleDropOver,
      onDropEnter: (_) => setState(() => _isDragOver = true),
      onDropLeave: (_) => setState(() => _isDragOver = false),
      onPerformDrop: _handlePerformDrop,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          border: _isDragOver
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: widget.child,
      ),
    );
  }

  DropOperation _handleDropOver(DropOverEvent event) {
    // Check if any item can be accepted.
    for (final item in event.session.items) {
      if (item.canProvide(Formats.fileUri)) {
        return DropOperation.copy;
      }
      for (final format in _imageFormats) {
        if (item.canProvide(format)) {
          return DropOperation.copy;
        }
      }
      if (item.canProvide(Formats.plainText)) {
        return DropOperation.copy;
      }
    }
    return DropOperation.none;
  }

  Future<void> _handlePerformDrop(PerformDropEvent event) async {
    setState(() => _isDragOver = false);

    for (final item in event.session.items) {
      final reader = item.dataReader;
      if (reader == null) continue;

      // Try file URI first.
      if (reader.canProvide(Formats.fileUri)) {
        _readFileUri(reader);
        continue;
      }

      // Try image formats.
      bool handled = false;
      for (final format in _imageFormats) {
        if (reader.canProvide(format)) {
          _readImageData(reader, format);
          handled = true;
          break;
        }
      }
      if (handled) continue;

      // Try plain text.
      if (reader.canProvide(Formats.plainText)) {
        _readPlainText(reader);
      }
    }
  }

  void _readFileUri(dynamic reader) {
    reader.getValue<Uri>(
      Formats.fileUri,
      (Uri? value) {
        if (value case final uri?) {
          if (widget.onFilesDropped case final callback?) {
            printLog('[DropRegionWrapper] Dropped file URI: $uri');
            callback([uri]);
          }
        }
      },
      onError: (error) {
        printLog('[DropRegionWrapper] Error reading file URI: $error');
      },
    );
  }

  void _readImageData(dynamic reader, dynamic format) {
    final extension = switch (format) {
      _ when format == Formats.png => 'png',
      _ when format == Formats.jpeg => 'jpg',
      _ when format == Formats.gif => 'gif',
      _ when format == Formats.webp => 'webp',
      _ => 'png',
    };

    reader.getFile(
      format,
      (file) async {
        final data = await file.readAll();
        if (widget.onDataDropped case final callback?) {
          printLog('Dropped image data: ${file.fileName}');
          callback(data, file.fileName, extension);
        }
      },
      onError: (error) {
        printLog('Error reading image data: $error');
      },
    );
  }

  void _readPlainText(dynamic reader) {
    reader.getValue<String>(
      Formats.plainText,
      (String? value) {
        if (value case final text?) {
          if (widget.onTextDropped case final callback?) {
            final preview = text.length > 50 ? text.substring(0, 50) : text;
            printLog('Dropped text: $preview...');
            callback(text);
          }
        }
      },
      onError: (error) {
        printLog('Error reading plain text: $error');
      },
    );
  }
}
