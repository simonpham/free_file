import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: Container(
        color: Colors.grey,
        child: const Center(
          child: Text('Status Bar'),
        ),
      ),
    );
  }
}
