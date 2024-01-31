import 'dart:io' as io;

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class ThumbnailWidget extends StatelessWidget {
  final File file;
  final double size;

  const ThumbnailWidget({
    super.key,
    required this.file,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ioFile = io.File(file.path.toRealPath());
    if (file.fileType == FileType.svg) {
      return SvgPicture.file(
        ioFile,
        width: size,
        height: size,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        placeholderBuilder: (context) {
          return ImageView(
            file.icon,
            width: size,
            height: size,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          );
        },
      );
    }
    return Image.file(
      ioFile,
      width: size,
      height: size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      gaplessPlayback: true,
      cacheHeight: size.toInt(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: FludaDuration.ms5,
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, _, __) {
        return ImageView(
          file.icon,
          width: size,
          height: size,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      },
    );
  }
}
