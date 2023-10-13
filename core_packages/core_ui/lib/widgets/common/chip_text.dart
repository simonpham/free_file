import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ChipText extends StatelessWidget {
  final String text;

  const ChipText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Spacing.d20,
      decoration: BoxDecoration(
        color: context.theme.chipTheme.backgroundColor,
        borderRadius: BorderRadius.circular(
          Spacing.d8,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.d8,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: context.theme.textTheme.bodySmall,
      ),
    );
  }
}
