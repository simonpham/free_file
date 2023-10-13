import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class EmptyWidget extends StatelessWidget {
  final String? image;
  final String title;
  final String subtitle;

  const EmptyWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null)
          ImageView(
            image!,
            size: Spacing.d1 * 172,
            fit: BoxFit.contain,
          ),
        Padding(
          padding: EdgeInsets.only(
            top: image != null ? Spacing.d24 : 0,
          ),
          child: Text(
            title,
            style: context.theme.textTheme.titleLarge,
          ),
        ),
        Text(
          subtitle,
          style: context.theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
