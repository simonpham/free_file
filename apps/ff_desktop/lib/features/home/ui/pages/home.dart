import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';
  static const routePath = '/$routeName';

  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
