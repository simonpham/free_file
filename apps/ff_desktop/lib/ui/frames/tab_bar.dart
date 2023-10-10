import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class HeheTabBar extends StatelessWidget {
  const HeheTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: Container(
        color: Colors.orange,
        child: const Center(
          child: Text('Hehe Tab Bar'),
        ),
      ),
    );
  }
}
