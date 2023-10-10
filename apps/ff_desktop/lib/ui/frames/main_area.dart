import 'package:flutter/material.dart';

class MainArea extends StatelessWidget {
  const MainArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: const Center(
        child: Text('Main Area'),
      ),
    );
  }
}
