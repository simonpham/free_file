import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class ImageView extends StatelessWidget {
  final dynamic data;
  final String? blurHash;

  final double? size;
  final double? width;
  final double? height;

  final BoxFit? fit;
  final Alignment? alignment;

  final Color? color;

  final String assetPackage;

  const ImageView(
    this.data, {
    super.key,
    this.size,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.color,
    this.blurHash,
    this.assetPackage = 'core_ui',
  }) : assert(
          (size == null && (width != null || height != null)) ||
              (size != null && width == null && height == null),
          'Either size or width and height must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final url = data;

    if (url is SvgGenImage) {
      return url.svg(
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
        package: assetPackage,
      );
    }

    if (url is! String) {
      return SizedBox(
        width: size ?? width,
        height: size ?? height,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade200,
          child: Container(
            color: Colors.white,
          ),
        ),
      );
    }

    if (url.isEmpty) {
      final isDark = context.theme.brightness == Brightness.dark;
      return SizedBox(
        width: size ?? width,
        height: size ?? height,
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
          child: Container(
            color: Colors.white,
          ),
        ),
      );
    }

    if (url.startsWith('/') && !kIsWeb) {
      return Image.network(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        color: color,
      );
    }

    if (url.startsWith('assets/')) {
      if (url.endsWith('.svg')) {
        return SvgPicture.asset(
          url,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center,
          colorFilter: color != null
              ? ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                )
              : null,
          package: assetPackage,
        );
      }

      return Image.asset(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        color: color,
        package: assetPackage,
      );
    }

    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
      );
    }

    return Image.network(
      url,
      width: size ?? width,
      height: size ?? height,
      fit: fit ?? BoxFit.cover,
      alignment: alignment ?? Alignment.center,
      color: color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return SizedBox(
          width: size ?? width,
          height: size ?? height,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade200,
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
