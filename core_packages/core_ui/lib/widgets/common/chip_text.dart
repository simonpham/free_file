import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

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
        color: context.chipBackgroundColor,
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
        style: context.caption1.copyWith(
          color: context.typoFadeColor,
        ),
      ),
    );
  }
}
