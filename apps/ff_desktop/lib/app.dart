import 'package:flutter/material.dart';

class FreeFile extends StatelessWidget {
  const FreeFile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FreeFile',
      home: Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
