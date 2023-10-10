import 'package:flutter/material.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: SizedBox(
        height: Spacing.d36,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.indigo,
                child: const Center(
                  child: Text('Tool Bar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
