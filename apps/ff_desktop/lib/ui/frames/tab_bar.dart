import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class HeheTabBar extends StatelessWidget {
  const HeheTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Spacing.d36,
      width: double.infinity,
      child: const AnimatedSize(
        curve: Curves.easeOut,
        duration: FludaDuration.ms3,
      ),
    );
  }
}
