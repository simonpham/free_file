import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

class AddressBar extends StatelessWidget {
  const AddressBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: FludaDuration.ms3,
      child: Container(
        color: Colors.yellow,
        child: const Center(
          child: Text('Address Bar'),
        ),
      ),
    );
  }
}
